import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insterprogram/videoplayer.dart';
import 'package:insterprogram/videoupload.dart';
// import 'dart:ui_web';
class DisplayContent extends StatefulWidget {
  const DisplayContent({Key? key}) : super(key: key);

  @override
  State<DisplayContent> createState() => _DisplayContentState();
}

class _DisplayContentState extends State<DisplayContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: ListTile(
          title: const Text('Content'),
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPickerScreen()),
              );
            },
            child: const Text('Post'),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('VideoInfo').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Colors.red,
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var courseData = snapshot.data!.docs[index].data();
              var title = courseData['title'] ?? 'No Name';
              var des = courseData['description'] ?? 'No Name';
              var cat = courseData['catagory'] ?? 'No Name';
              var url = courseData['url'] ?? 'No Name';

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: VideoPlayerScreen(url: url)),
                      Text('Title: $title'),
                      Text('Description: $des'),
                      Text('Category: $cat'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
