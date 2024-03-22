import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/videodata.dart';
import 'package:flyin/pages/HomePage/elements/videolist.dart';
import 'package:flyin/pages/VideoPage/VideoElement/commentSec.dart';
import 'package:flyin/pages/VideoPage/VideoElement/videoElement.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  const VideoView({super.key, required this.videoData});
  final VideoData videoData;
  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  bool searchClicked = false;

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  XFile? _image;
  bool showimg = false;

  @override
  void initState() {
    print("url : ${widget.videoData.videoUrl}");
    super.initState();
    _controller = _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoData.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          showimg = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'FLYIN',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: screenWidth * 0.6,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 218, 233, 141),
                      borderRadius: BorderRadius.circular(20)),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    CupertinoIcons.bell,
                    size: 30,
                  ),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    // width: screenWidth,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    VideoPlayer(_controller),
                                    ClosedCaption(
                                        text: _controller.value.caption.text),
                                    // _ControlsOverlay(controller: _controller),
                                    VideoProgressIndicator(
                                      _controller,
                                      allowScrubbing:
                                          true, // Allow user to scrub through the video
                                      padding: EdgeInsets.all(2.0),
                                    ),

                                    showimg
                                        ? InkWell(
                                            onTap: () {
                                              _controller.play();
                                              setState(() {
                                                showimg = false;
                                              });
                                            },
                                            child: SizedBox(
                                              height: screenHeight * 0.4,
                                              width: screenWidth,
                                              child: showimg
                                                  ? Image.network(
                                                      widget.videoData.imgUrl,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : SizedBox(),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fast_rewind_rounded,
                              size: 45,
                              color: Colors.black38,
                            ),
                            SizedBox(
                              width: screenWidth * 0.08,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showimg = false;
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                size: 55,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.08,
                            ),
                            Icon(
                              Icons.fast_forward_rounded,
                              size: 45,
                              color: Colors.black38,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Container(
              height: screenHeight * 0.32,
              child: VideoElement(videoData: widget.videoData),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8),
              child: Divider(color: Colors.black12, thickness: 2),
            ),
            VideoList(screenWidth: screenWidth, screenHeight: screenHeight),
            CommentContainer(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              videoData: widget.videoData,
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }
}
