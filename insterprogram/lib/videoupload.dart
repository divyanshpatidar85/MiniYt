import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:insterprogram/alertbox.dart';
import 'package:insterprogram/db.dart';
import 'package:insterprogram/fireStorageMethod.dart';

class VideoPickerScreen extends StatefulWidget {
  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  VideoPlayerController? _controller;
  late XFile _videoFile;
  late ChewieController _chewieController;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  String catagory = 'Kids'; // Default value
  List<String> catag = ['Kids', 'Adult', 'Both'];

  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      final newController = VideoPlayerController.file(
        File(pickedFile.path),
      );

      if (!kIsWeb) {
        await newController.initialize();
      }

      setState(() {
        _videoFile = pickedFile;
        _controller = newController;

        if (kIsWeb) {
          _controller!.initialize().then((_) {
            _controller!.play();
          });
        } else {
          _chewieController = ChewieController(
            videoPlayerController: _controller!,
            autoPlay: true,
            looping: false,
          );
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(''), // Empty URL initially
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Picker'),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              if (_controller != null && _controller!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: kIsWeb
                      ? VideoPlayer(_controller!)
                      : Chewie(controller: _chewieController),
                ),
              _controller == null
                  ? ElevatedButton(
                      onPressed: _pickVideo,
                      child: const Text('Pick Video'),
                    )
                  : const Text(''),
              const SizedBox(height: 10,),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    children: [
                      TextField(
                        controller: title,
                        decoration: InputDecoration(
                          label: const Text('Title of your video'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      TextField(
                        controller: description,
                        maxLines: 12,
                        decoration: InputDecoration(
                          label: const Text('Description'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      DropdownButton<String>(
                        value: catagory,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              catagory = newValue;
                            });
                          }
                        },
                        items: catag
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: () async {
                          if (title.text.isNotEmpty &&
                              description.text.isNotEmpty &&
                              _videoFile != null) {
                            Uint8List file =
                                await StorageMethods().convertXFileToUint8List(_videoFile);
                            String downloadUrl =
                                await StorageMethods().uploadVideoToStorage(file);

                            if (downloadUrl != null) {
                              String res = await Db().StoreInfo(
                                title.text,
                                description.text,
                                catagory,
                                downloadUrl,
                              );

                              if (res == "success") {
                                title.text = "";
                                description.text = "";
                                downloadUrl = "";
                                _controller = null;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShowAlterDialog(alert: "Successfully uploaded"),
                                  ),
                                );
                              }
                            }
                          } else {
                            print("Kindly Fill the Details");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowAlterDialog(alert: "Kindly Fill the Details"),
                              ),
                            );
                          }
                        },
                        child: const Text("Post Video"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

