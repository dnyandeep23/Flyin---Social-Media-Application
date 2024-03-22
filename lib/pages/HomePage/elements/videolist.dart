import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/videodata.dart';
import 'package:flyin/pages/HomePage/elements/singlevideo.dart';
import 'package:flyin/pages/VideoPage/videoViewPage.dart';

class VideoList extends StatefulWidget {
  const VideoList(
      {super.key, required this.screenWidth, required this.screenHeight});
  final double screenWidth;
  final double screenHeight;

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<VideoData> videos = [];


  @override
  void initState() {
    super.initState();

    setState(() {
      retriveData();
    });
  }


  void retriveData() {
    DatabaseReference dbRef = FirebaseDatabase.instance.ref('videos');
    dbRef.onValue.listen((DatabaseEvent event) {
      Object? data = event.snapshot.value;
      if (data is Map<Object?, Object?>) {
        // Successfully casted to Map
        Map<dynamic, dynamic> dataMap = data;

        // Now you can use dataMap for further processing
        dataMap.forEach((key, value) {
          print('$key: $value');
          if (value is Map<Object?, Object?>) {
            // value.forEach((key, value) {
            print(value);
            VideoData video =
                VideoData.fromJson(Map<String, dynamic>.from(value));
            videos.add(video);
            // });
          } else {
            print("no");
          }
        });
      } else {
        print('Data is not in the expected Map<dynamic, dynamic> format');
      }
      print(data.runtimeType);
      for (VideoData video in videos) {
        print('Title: ${video.title}, Category: ${video.category}');
        // Add more logic as needed
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VideoView(videoData: videos[index])));
                      },
                      child: SingleVideo(
                        screenHeight: widget.screenHeight,
                        screenWidth: widget.screenWidth,
                        videoData: videos[index],
                      ),
                    );
                  },
                )
              
        ),
      ),
    );
  }
}
