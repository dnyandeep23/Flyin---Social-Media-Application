import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/persondata.dart';
import 'package:flyin/pages/Profile/profilepage.dart';
import 'package:flyin/pages/Record%20Video/post/post_before.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;
  final List<CameraDescription> cameras;
  final String phone;
  final Person person;

  const VideoPlayerScreen(
      {Key? key, required this.videoPath, required this.cameras, required this.phone, required this.person})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  XFile? _image;
  bool showimg = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath));
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
    _controller.dispose();
    super.dispose();
  }

  void addthumb(XFile img) {
    _image = img;
    print(_image!.path);
    setState(() {
      if (_image != null) {
        showimg = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;

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
                    child: FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
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
                                              ? Image.file(
                                                  File(_image!.path),
                                                  fit: BoxFit.fill,
                                                )
                                              : SizedBox(),
                                        ),
                                      )
                                    : const SizedBox()
                              ],
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Icon(
                    Icons.fast_rewind_rounded,
                    size: 45,
                  ),
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
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 255, 123),
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 55,
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.08,
                ),
                Container(
                  child: Icon(
                    Icons.fast_forward_rounded,
                    size: 45,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Divider(color: Colors.black26, thickness: 2),
            ),
            PostBefore(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                addthumb: addthumb,
                videoPath: widget.videoPath,
                cameras: widget.cameras,phone: widget.phone,person: widget.person,),
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
