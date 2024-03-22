import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyin/Model/videodata.dart';

class SingleVideo extends StatefulWidget {
  const SingleVideo({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.videoData,
  });
  final double screenWidth;
  final double screenHeight;
  final VideoData videoData;
  @override
  State<SingleVideo> createState() => _SingleVideoState();
}

class _SingleVideoState extends State<SingleVideo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.screenWidth,
      height: widget.screenHeight * 0.2,
      decoration: BoxDecoration(
          color: Color.fromARGB(15, 0, 0, 0),
          borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.only(top: widget.screenHeight * 0.02),
      child: Row(
        children: [
          SizedBox(
            width: widget.screenWidth * 0.02,
          ),
          Container(
            height: widget.screenHeight * 0.18,
            width: widget.screenWidth * 0.4,
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.videoData.imgUrl,
                  fit: BoxFit.fitHeight,
                )),
          ),
          SizedBox(
            width: widget.screenWidth * 0.02,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.videoData.title}',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: widget.screenHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widget.screenWidth * 0.06,
                    height: widget.screenWidth * 0.06,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.black),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(widget.videoData.profilePic),
                    ),
                  ),
                  SizedBox(
                    width: widget.screenWidth * 0.02,
                  ),
                  Text(
                    widget.videoData.username,
                    style: TextStyle(),
                  )
                ],
              ),
              SizedBox(
                height: widget.screenHeight * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      CupertinoIcons.map_pin,
                      size: 15,
                    ),
                  ),
                  SizedBox(
                    width: widget.screenWidth * 0.005,
                  ),
                  Text(
                    '${widget.videoData.location}',
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
              SizedBox(
                height: widget.screenHeight * 0.003,
              ),
              Text(
                '  Category: ${widget.videoData.category}',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: widget.screenHeight * 0.003,
              ),
              Text(
                '  Posted ${DateTime.now().difference(DateTime.parse(widget.videoData.date)).inDays} days ago',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: widget.screenHeight * 0.003,
              ),
              Text(
                '  ${widget.videoData.view} Views',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }
}
