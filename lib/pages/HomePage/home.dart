import 'package:camera/camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/persondata.dart';
import 'package:flyin/Model/videodata.dart';
import 'package:flyin/pages/HomePage/elements/searchvideo.dart';
import 'package:flyin/pages/HomePage/elements/singlevideo.dart';
import 'package:flyin/pages/HomePage/elements/videolist.dart';
import 'package:flyin/pages/Profile/profilepage.dart';
import 'package:flyin/pages/VideoPage/videoViewPage.dart';
import 'package:flyin/utils/mydrawer.dart';
import 'package:flyin/pages/Record%20Video/camera.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.cameras,
    required this.phone,
  });
  final List<CameraDescription> cameras;
  final String phone;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Person? person;
  bool searchClicked = false;
  late String text = '';
  final TextEditingController _search = TextEditingController();
  List<VideoData> videos = [];
  List<VideoData> searchvideos = [];
  bool setshow = false;

  void initState() {
    super.initState();
    retrive();
    // retriveSearchData();
  }

  void retrive() async {
    String name = '', phone = '', pic = '';
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users').get();
    dynamic map = snapshot.value;
    if (map is Map<Object?, Object?>) {
      Map<Object?, Object?> item = map;
      print(item.keys);
      item.forEach((key, element) {
        if (element is Map<Object?, Object?>) {
          print(element);
          print(key);

          if (key == widget.phone) {
            print(element['phone']);
            name = element['username'].toString();
            pic = element['profilePic'].toString();
            phone = element['phone'].toString();
          }
        }
      });
    }
    setState(() {
      person = Person(phone: phone, username: name, profilePic: pic);
    });

    print(person!.profilePic.toString());
  }

  void handleSearch(String text) {
    searchvideos.clear();
    List<VideoData> data = [];
    print(text);
    print("Iam ::: $videos");
    videos.forEach((item) {
      print("Iam ::: ${item.title}");
      if (item.title.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          print("Iam ::: $item");
          data.add(item);
        });
      }
    });
    print('Im search : ${searchvideos}');
    setState(() {
      print(searchvideos.length);
      searchvideos = filterVideosByUniqueId(data);
    });
    print(searchvideos);
  }

  List<VideoData> filterVideosByUniqueId(List<VideoData> videos) {
    // Create a Set to keep track of unique video uniqueIds
    Set<String> uniqueIds = Set<String>();

    // Create a List to store the filtered video data
    List<VideoData> filteredVideos = [];

    // Iterate through the input list
    for (VideoData video in videos) {
      // Check if the uniqueId is not already in the Set
      if (!uniqueIds.contains(video.uniqueid)) {
        // Add the uniqueId to the Set (to track uniqueness)
        uniqueIds.add(video.uniqueid);

        // Add the video to the filtered list
        filteredVideos.add(video);
      }
    }

    return filteredVideos;
  }

  void retriveSearchData() {
    searchvideos.clear();
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
      setState(() {
        searchvideos.clear();
      });
      handleSearch(_search.text);
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
            child: Stack(children: [
              Column(
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
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenWidth * 0.75,
                              height: screenHeight * 0.06,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Color.fromARGB(255, 222, 216, 216)),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.02,
                                  ),
                                  Icon(
                                    CupertinoIcons.search,
                                    size: 30,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.04,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          width: screenWidth * 0.5,
                                          child: TextField(
                                            controller: _search,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Search Here'),
                                            keyboardType: TextInputType.name,
                                            onChanged: (value) {
                                              if (value.isNotEmpty) {
                                                print(_search.text.isNotEmpty);
                                                setState(() {
                                                  setshow = true;
                                                  searchvideos.clear();
                                                });
                                                retriveSearchData();
                                              } else {
                                                setState(() {
                                                  setshow = false;
                                                });
                                              }
                                            },
                                          )),
                                      SizedBox(
                                        width: screenWidth * 0.03,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              searchClicked = false;
                                              _search.clear();
                                              setshow = false;
                                            });
                                          },
                                          child: Icon(Icons.clear))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.03,
                            ),
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 242, 241, 241)),
                              child: Icon(
                                Icons.filter_alt_rounded,
                                size: 35,
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              height: screenHeight * 0.8,
                              child: VideoList(
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth),
                            ),
                            setshow
                                ? Container(
                                    height: screenHeight * 0.5,
                                    width: screenWidth,
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.2), // shadow color
                                          spreadRadius:
                                              4, // how much the shadow should spread
                                          blurRadius:
                                              4, // how blurry the shadow should be
                                          offset: Offset(
                                              0, 2), // offset of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: screenHeight * 0.45,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          child: searchvideos.isNotEmpty
                                              ? ListView.builder(
                                                  itemCount:
                                                      searchvideos.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    VideoView(
                                                                        videoData:
                                                                            searchvideos[index])));
                                                      },
                                                      child: SingleVideo(
                                                        screenHeight:
                                                            screenHeight,
                                                        screenWidth:
                                                            screenWidth,
                                                        videoData: searchvideos[
                                                            index], // Pass the relevant VideoData here
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                        './assets/nofound.png',
                                                        height:
                                                            screenHeight * 0.39,
                                                      ),
                                                      Text(
                                                        'No Data Found',
                                                        style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 3.5),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Camera(
                            cameras: widget.cameras,
                            phone: widget.phone,
                            person: person ??
                                Person(username: '', phone: '', profilePic: ''),
                          ),
                        ));
                  },
                  child: Icon(Icons.add),
                ),
              )
            ]),
          ),
        ),
      ),
      drawer: Mydrawer(
        height: screenHeight,
        width: screenWidth,
        cameras: widget.cameras,
        phone: widget.phone,
        person: person ?? Person(username: '', phone: '', profilePic: ''),
      ),
    );
  }
}
