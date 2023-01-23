import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? name;
  final String? uid;
  final String? email;
  final String? image;
  final String? points;
  final String? title;

  List<String?>? bookmarks;
  List<String?>? challengeResponds;
  List<String?>? likes;
  final Timestamp? createdTime;


  UserModel({
    this.image,
    this.points,
    this.title,
    this.bookmarks,
    this.challengeResponds,
    this.likes,
    this.createdTime,
    this.name,
    this.uid,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      if(name != null) 'name': name,
      if(email != null) 'email': email,
      if(uid != null) 'uid':uid,
      if(image != null) 'image': image,
      if(points != null) 'points': points,
      if(title != null) 'title': title,
      if(bookmarks != null) 'bookmarks':bookmarks,
      if(challengeResponds != null) 'challengeResponds':challengeResponds,
      if(likes != null) 'likes':likes,
      if(createdTime != null) 'createdTime':createdTime
    };
  }

  factory UserModel.fromMap(Map<String,dynamic> data) {
    return UserModel(
      name : data['name'] ?? '',
      uid : data['uid'] ?? '',
      email : data['email'] ?? '',
      image: data['image'] ?? '',
      points: data['points'] ?? '',
      title: data['title'] ?? '',
      bookmarks: data['bookmarks'] ?? [],
      challengeResponds: data['challengeResponds'] ?? [],
      likes: data['likes'] ?? [],
      createdTime: data['createdTime']
    );
  }

}