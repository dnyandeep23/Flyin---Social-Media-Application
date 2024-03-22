import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/persondata.dart';
import 'package:flyin/pages/HomePage/home.dart';
import 'package:flyin/pages/Profile/profilepage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

class PostBefore extends StatefulWidget {
  const PostBefore({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.addthumb,
    required this.videoPath,
    required this.cameras, required this.phone, required this.person,
  }) : super(key: key);
  final double screenHeight;
  final double screenWidth;
  final String videoPath;
  final List<CameraDescription> cameras;
  final String phone;
  final Person person;

  @override
  _PostBeforeState createState() => _PostBeforeState();

  final void Function(XFile img) addthumb;
}

class _PostBeforeState extends State<PostBefore> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late XFile? _image;
  String location = 'Location is not available';
  bool clicked = false;
  bool imgpicked = false;
  String selectedOption = 'Select';
  var items = [
    'Select',
    'Sports',
    'Adventure',
    'Others',
  ];
  Future<void> getLocation() async {
    try {
      // Check if location services are enabled
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled) {
        // Get the current position (latitude and longitude)
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );

        // Get the place name (address) from the coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        // Display the location message
        setState(() {
          if (placemarks.isNotEmpty) {
            //
            print("Place Name: ${placemarks[0].name}\n" +
                "Address: ${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}");
            setState(() {
              location =
                  '${placemarks[0].locality}, ${placemarks[0].administrativeArea}';
              clicked = false;
            });
          } else {
            print("Place name not available.");
          }
        });
      } else {
        setState(() {
          print("Location services are disabled.");
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        print("Error fetching location.");
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedImage;
        if (pickedImage != null) {
          imgpicked = true;
          widget.addthumb(_image!);
        }
        print(_image!.path);
      });
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = widget.screenWidth;
    double screenHeight = widget.screenHeight;
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                      onTap: () {
                        setState(() {
                          clicked = true;
                          location = 'Wait..';
                          getLocation();
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: screenWidth,
                        height: screenHeight * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                            Icon(
                              CupertinoIcons.map_pin,
                              size: 25,
                            ),
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                            Text(
                              location,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18),
                            ),
                            clicked
                                ? SizedBox(
                                    width: screenWidth * 0.45,
                                  )
                                : SizedBox(),
                            clicked
                                ? Container(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  Text('Category: $selectedOption'),
                  SizedBox(height: 2),
                  Container(
                    width: screenWidth,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<String>(
                      value: selectedOption,
                      icon: Container(
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.arrow_drop_down)),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedOption = newValue!;
                        });
                      },
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text('   $value'),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      height: screenHeight * 0.07,
                      alignment: Alignment.center,
                      width: screenWidth,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.black, style: BorderStyle.solid)),
                      child: Text(
                        !imgpicked ? 'Upload Thumbnail' : ' ✅   Uploded',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.08),
                  Container(
                      child: ElevatedButton(
                          onPressed: () {
                            handleButtonClick();
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(
                                  Size(screenWidth, screenHeight * 0.06)),
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 150, 199, 91))),
                          child: Text(
                            'Post',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          )))
                ],
              ),
            )
          ],
        ));
  }

  void handleButtonClick() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    var uuid = Uuid();
    String uniqueid = uuid.v1();
    String imgUrl = '';
    String videoUrl = '';
    print('clicked');
    String title = titleController.text.trim();
    // ignore: unnecessary_null_comparison
    if (title != null &&
        widget.videoPath != null &&
        _image != null &&
        location != null &&
        selectedOption != 'Select') {
      String filename = '${DateTime.now()}_image.png ';
      String videofilename = '${DateTime.now()}_video.mp4 ';

      final storageRef = FirebaseStorage.instance.ref();
      final videoRef = FirebaseStorage.instance.ref();
      final imgfileRef = storageRef.child(filename);
      final videofileRef = videoRef.child(videofilename);
      File file = File(_image!.path);
      File videofile = File(widget.videoPath);

      try {
        await imgfileRef.putFile(
          file,
          SettableMetadata(contentType: 'image/png'),
        );

        await videofileRef.putFile(
          videofile,
          SettableMetadata(contentType: 'video/mp4'),
        );

        imgUrl = await imgfileRef.getDownloadURL();
        videoUrl = await videofileRef.getDownloadURL();
      } on FirebaseException catch (e) {
        print('Error uploading image: $e');
      }

      await ref.child('videos').child(uniqueid).set({
        "uniqueid": uniqueid,
        'imgUrl': imgUrl,
        'VideoUrl': videoUrl,
        "title": title,
        "username": widget.person.username,
        "profilePic": widget.person.profilePic,
        "category": selectedOption,
        "location": location,
        "like": 0,
        "dislike": 0,
        "view": 0,
        'date': DateTime.now().toString()
      });

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(cameras: widget.cameras,phone: widget.phone,),
          ));
    }
  }
}
