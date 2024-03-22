import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/persondata.dart';
import 'package:flyin/pages/HomePage/home.dart';
import 'package:flyin/pages/Profile/profilepage.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer(
      {Key? key,
      required this.height,
      required this.width,
      required this.cameras,
      required this.phone,
      required this.person})
      : super(key: key);
  final double height;
  final double width;
  final String phone;
  final Person person;
  final List<CameraDescription> cameras;

  @override
  _MydrawerState createState() => _MydrawerState(height: height, width: width);
}

class _MydrawerState extends State<Mydrawer> {
  final double height;
  final double width;

  _MydrawerState({required this.height, required this.width});
  Color homeColor = Colors.transparent; // Initial color
  Color homeelementColor = Colors.black; // Initial color
  Color profileColor = Colors.transparent; // Initial color
  Color profileelementColor = Colors.black; // Initial color

  void _changeHomeColor() {
    setState(() {
      homeelementColor = Colors.white;
      homeColor = Colors.black;
      profileColor = Colors.transparent;
      profileelementColor = Colors.black;
    });
  }

  void _changeProfileColor() {
    setState(() {
      homeelementColor = Colors.black;
      homeColor = Colors.transparent;
      profileColor = Colors.black;
      profileelementColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.7,
      // color: Colors.amberAccent,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40), topRight: Radius.circular(40))),
      child: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              currentAccountPicture: Container(
                width: width * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(100)),
                padding: EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                      width: width * 0.08,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.network(
                        widget.person.profilePic,
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              currentAccountPictureSize: Size(width * 0.2, width * 0.2),
              accountName: Text(
                "",
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              decoration: const BoxDecoration(color: Colors.transparent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: homeColor,
                    width: 1.0,
                  ),
                  color: homeColor),
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.home,
                  color: homeelementColor,
                ),
                // tileColor: emailColor,
                title: Text(
                  "Home",
                  textScaler: TextScaler.linear(1.2),
                  style: TextStyle(color: homeelementColor),
                ),
                hoverColor: Colors.black,
                onTap: () {
                  _changeHomeColor();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Home(
                      cameras: widget.cameras,
                      phone: widget.phone,
                      
                    ),
                  ));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: profileColor,
                    width: 1.0,
                  ),
                  color: profileColor),
              child: ListTile(
                leading: Icon(
                  CupertinoIcons.person,
                  color: profileelementColor,
                ),
                // tileColor: emailColor,
                title: Text(
                  "Profile",
                  textScaler: TextScaler.linear(1.2),
                  style: TextStyle(color: profileelementColor),
                ),
                hoverColor: Colors.black,
                onTap: () {
                  _changeProfileColor();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Profile(
                      cameras: widget.cameras,
                      phone: widget.phone,
                     person: widget.person,
                    ),
                  ));
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
