class VideoData {
  late String date;
  late String imgUrl;
  late int view;
  late int like;
  late int dislike;
  late String location;
  late String category;
  late String title;
  late String uniqueid;
  late String videoUrl;
  late String username;
  late String profilePic;

  VideoData({
    required this.date,
    required this.imgUrl,
    required this.view,
    required this.like,
    required this.dislike,
    required this.location,
    required this.category,
    required this.title,
    required this.uniqueid,
    required this.videoUrl,
    required this.username,
    required this.profilePic,
  });

  factory VideoData.fromJson(Map<String, dynamic> json) {
    return VideoData(
      date: json['date'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      view: json['view'] ?? 0,
      like: json['like'] ?? 0,
      dislike: json['dislike'] ?? 0,
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      uniqueid: json['uniqueid'] ?? '',
      videoUrl: json['VideoUrl'] ?? '',
      username: json['username']??'',
      profilePic: json['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'imgUrl': imgUrl,
      'view': view,
      'like': like,
      'dislike': dislike,
      'location': location,
      'category': category,
      'title': title,
      'uniqueid': uniqueid,
      'videoUrl': videoUrl,
    };
  }
}
