import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/persondata.dart';
import 'package:flyin/pages/Profile/profilepage.dart';
import 'package:flyin/pages/Record%20Video/video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.cameras, required this.phone, required this.person});
  final List<CameraDescription> cameras;
  final String phone;
  final Person person;
  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool handleVideoClick = false;
  String a = "";
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    requestStoragePermission();
    _initializeCamera();
  }

  void _initializeCamera() {
    _controller = CameraController(
        widget.cameras[_selectedCameraIndex], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  void _onSwitchCamera() {
    int newCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;

    _controller.dispose(); // Dispose of the current controller
    _selectedCameraIndex = newCameraIndex;
    _initializeCamera(); // Initialize the new controller with the selected camera
  }

  Future<String> getDownloadsDirectoryPath() async {
    final directory = await getDownloadsDirectoryPath();
    return directory;
  }

  Future<void> _requestPermissions() async {
    var cameraStatus = await Permission.camera.request();
    var locationStatus = await Permission.location.request();

    if (cameraStatus.isGranted && locationStatus.isGranted) {
      // Both camera and location permissions are granted
      print('Camera and location permissions granted');
    } else {
      // Handle accordingly if permissions are not granted
      print('Camera or location permissions denied');
    }
  }

  void moveVideoToDownloads(XFile videoFile) async {
    String downloadsDirectoryPath = await getDownloadsDirectoryPath();
    String videoFileName =
        'my_recorded_video.mp4'; // You can use a dynamic name or the original file name

    String destinationPath = '$downloadsDirectoryPath/$videoFileName';

    try {
      // Move or copy the file to the downloads directory
      await File(videoFile.path).copy(destinationPath);

      print('Video moved to downloads: $destinationPath');
    } catch (e) {
      print('Error moving video to downloads: $e');
    }
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();

    // if (status.isGranted) {
    //   // Storage permission granted, proceed with file operations
    // } else {
    //   // Handle accordingly if storage permission is denied
    // }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            // margin: EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
            child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(color: Colors.black54),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        handleVideoClick = !handleVideoClick;
                      });
                      try {
                        await _initializeControllerFuture;

                        // Start video recording
                        if (!_controller.value.isRecordingVideo) {
                          // final String path = join((await getDownloadsDirectory())!.path,'${DateTime.now()}.mp4',);
                          await _controller.startVideoRecording();
                        } else {
                          // Stop recording
                          XFile videoFile =
                              await _controller.stopVideoRecording();
// moveVideoToDownloads(videoFile);
                          String title = 'My Video Title ${DateTime.now()}';
                          String description = 'Video Description';

                          // await uploadVideoAndAddMetadata(videoFile, title, description);
                          print('Video recorded: ${videoFile.path}');
                          setState(() {
                            a = 'Video recorded: ${videoFile.path}';
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerScreen(
                                videoPath: videoFile.path.toString(),
                                cameras: widget.cameras,
                                phone: widget.phone,
                                person: widget.person,
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 3),
                          borderRadius: BorderRadius.circular(100)),
                      child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: !handleVideoClick
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(100)),
                          child: !handleVideoClick
                              ? Icon(
                                  Icons.videocam,
                                  size: 30,
                                )
                              : Icon(Icons.pause,
                                  color: Colors.white, size: 30)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
              right: screenWidth * 0.08,
              bottom: screenHeight * 0.055,
              child: InkWell(
                onTap: () {
                  _onSwitchCamera();
                },
                child: Icon(
                  CupertinoIcons.camera_rotate,
                  color: Colors.white,
                  size: 35,
                ),
              ))
        ],
      ),
    );
  }
}
