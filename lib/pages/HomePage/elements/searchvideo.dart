import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/videodata.dart';
import 'package:flyin/pages/HomePage/elements/singlevideo.dart';
import 'package:flyin/pages/VideoPage/videoViewPage.dart';

class SearchVideo extends StatefulWidget {
  const SearchVideo(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.searchtext, required this.searchvideos});
  final double screenWidth;
  final double screenHeight;
  final String searchtext;
  final List<VideoData> searchvideos;
  @override
  State<SearchVideo> createState() => _SearchVideoState();
}

class _SearchVideoState extends State<SearchVideo> {
  

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   retriveData();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // child: 
    );
  }
}
