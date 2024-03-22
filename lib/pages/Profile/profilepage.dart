import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/persondata.dart';
import 'package:flyin/utils/mydrawer.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.cameras,
      required this.phone,
      required this.person});
  final List<CameraDescription> cameras;
  final String phone;
  final Person person;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isTextedit = false;
  final TextEditingController _person = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _person.text = widget.person.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Container(
                    width: screenWidth * 0.45,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40)),
                          child: Image.network(
                            widget.person?.profilePic.isEmpty ?? true
                                ? 'https://firebasestorage.googleapis.com/v0/b/flyin-79b30.appspot.com/o/836-removebg-preview.png?alt=media&token=720f22c7-d2e4-4aaf-be4d-391859c5840b'
                                : widget.person?.profilePic ?? '',
                            fit: BoxFit.fill,
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Stack(
                  children: [
                    Container(
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(40)),
                      child: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "User Name",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.0002,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: TextField(
                              readOnly: !isTextedit,
                              controller: _person,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 4,
                                    style: BorderStyle.solid),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isTextedit = false;
                          });
                        },
                        child: Icon(
                          CupertinoIcons.pencil_circle_fill,
                          color: Colors.black38,
                          size: 45,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      drawer: Mydrawer(
          height: screenHeight,
          width: screenWidth,
          cameras: widget.cameras,
          phone: widget.phone,
          person: widget.person),
    );
  }
}
