import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/videodata.dart';

class VideoElement extends StatefulWidget {
  const VideoElement({Key? key, required this.videoData}) : super(key: key);
  final VideoData videoData;
  @override
  _VideoElementState createState() => _VideoElementState();
}

class _VideoElementState extends State<VideoElement> {
  List<VideoData> videos = [];
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.videoData.title,
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_up_alt_rounded,
                      color: Colors.black38,
                      size: 30,
                    ),
                    SizedBox(
                      width: screenWidth * 0.015,
                    ),
                    Text(
                      '${widget.videoData.like}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.1,
              ),
              Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.thumb_down_alt_rounded,
                      color: Colors.black38,
                      size: 30,
                    ),
                    SizedBox(
                      width: screenWidth * 0.015,
                    ),
                    Text(
                      '${widget.videoData.dislike}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth * 0.44,
              ),
              Container(
                child: Icon(
                  Icons.ios_share_rounded,
                  color: Colors.black38,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Row(
            children: [
              Container(
                  child: Text(
                '${widget.videoData.view + 1} views',
                style: TextStyle(fontSize: 16),
              )),
              SizedBox(
                width: screenWidth * 0.1,
              ),
              Container(
                  child: Text(
                '${DateTime.now().difference(DateTime.parse(widget.videoData.date)).inDays} days ago',
                style: TextStyle(fontSize: 16),
              )),
            ],
          ),
          SizedBox(
            height: screenHeight * 0.015,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Category : ${widget.videoData.category}',
                style: TextStyle(fontSize: 14),
              )),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                ' ${widget.videoData.location}',
                style: TextStyle(fontSize: 14),
              )),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(20, 0, 0, 0)),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(widget.videoData.profilePic),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.05,
                ),
                Text(
                  '${widget.videoData.username}',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
