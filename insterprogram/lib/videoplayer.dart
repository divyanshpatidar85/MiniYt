import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

// ignore: deprecated_member_use
_controller = VideoPlayerController.network(widget.url,
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
  );

  _chewieController = ChewieController(
    videoPlayerController: _controller,
    autoPlay: false,
    looping: false,
    // Other Chewie options...
  );

  _controller.initialize().then((_) {
    print('Video Player Initialized');
    setState(() {});
    }).catchError((error) {
      print('Error initializing video player: $error');
      // Show an error message on the UI if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized?
        kIsWeb?AspectRatio(aspectRatio:_controller.value.aspectRatio,
         child:VideoPlayer(_controller),
        ):Chewie(controller: _chewieController)
            :const CircularProgressIndicator(),
            
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
