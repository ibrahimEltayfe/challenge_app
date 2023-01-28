import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String? name;
  String? uid;
  String? email;
  String? image;
  String? points;
  String? title;
  bool? isVerified;

  List<String?>? bookmarks;
  List<String?>? challengeResponds;
  List<String?>? likes;

  Timestamp? createdTime;

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
    this.isVerified
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
      if(createdTime != null) 'createdTime':createdTime,
      if(isVerified != null) 'isVerified' : isVerified
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
      createdTime: data['createdTime'],
      isVerified : data['isVerified']
    );
  }

  UserModel initialize() {
    return UserModel(
      name: '',
      email: '',
      uid:'',
      image: '',
      points: '0',
      title: '',
      bookmarks: [],
      challengeResponds:[],
      likes:[],
      createdTime: null,
      isVerified: false
    );
  }

}