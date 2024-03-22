import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/videodata.dart';
import 'package:uuid/uuid.dart';

class CommentContainer extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final VideoData videoData;

  CommentContainer(
      {required this.screenWidth,
      required this.screenHeight,
      required this.videoData});

  @override
  _CommentContainerState createState() => _CommentContainerState();
}

class _CommentContainerState extends State<CommentContainer> {
  final TextEditingController _comment = TextEditingController();
  List<String> comments = [];

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
            value.forEach((key, value) {
              if (key == 'comments') {
                print(value);
                if (value is Map<Object?, Object?>) {
                  value.forEach((key, value) {
                    setState(() {
                      comments.add(value.toString());
                    });
                  });
                }
              }
            });
          } else {
            print("no");
          }
        });
      } else {
        print('Data is not in the expected Map<dynamic, dynamic> format');
      }
      // print(data.runtimeType);

      setState(() {
        print(comments);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth,
      height: widget.screenHeight * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        color: Colors.black12,
      ),
      child: Column(
        children: [
          // Header with title or user information
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                comments.clear();
                retriveData();
              },
              child: Text(
                'Comments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // List of comments
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return CommentTile(comment: comments[index]);
              },
            ),
          ),
          // Comment input field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _comment,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("videos");

                    var u = Uuid();
                    String uniqueid = u.v4();
                    await ref
                        .child(widget.videoData.uniqueid)
                        .child('comments')
                        .update({
                      "$uniqueid": _comment.text,
                    });

                    _comment.clear();
                  },
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentTile extends StatelessWidget {
  final String comment;

  CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.black12),
          padding: EdgeInsets.all(10),
          child: Text(
            comment,
            style: TextStyle(color: Colors.black),
          )),
      // You can customize the appearance of each comment tile here
    );
  }
}
