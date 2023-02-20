import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeModel{
  int? numOfBookmarks;
  String? categoryId;
  String? contentUrl;
  Timestamp? createdTime;
  String? id;
  bool? isTrendy;
  int? points;
  String? title;

  ChallengeModel({
    this.points,
    this.createdTime,
    this.title,
    this.id,
    this.isTrendy,
    this.categoryId,
    this.contentUrl,
    this.numOfBookmarks
  });

  Map<String, dynamic> toMap() {
    return {
      if(numOfBookmarks != null) 'numOfBookmarks': numOfBookmarks,
      if(categoryId != null) 'categoryId': categoryId,
      if(contentUrl != null) 'contentUrl':contentUrl,
      if(createdTime != null) 'createdTime': createdTime,
      if(id != null) 'id': id!,
      if(isTrendy != null) 'isTrendy': isTrendy,
      if(points != null) 'points':points,
      if(title != null) 'title':title,
    };
  }

  factory ChallengeModel.fromMap(Map<String,dynamic> data) {
    return ChallengeModel(
      numOfBookmarks: (data['numOfBookmarks']??0).toInt(),
      categoryId: data['categoryId'] ?? '',
      contentUrl: data['contentUrl'] ?? '',
      createdTime: data['createdTime'],
      id: data['id'] ?? '',
      isTrendy: data['isTrendy'] ?? false,
      points: (data['points']??0).toInt(),
      title: data['title'] ?? '',
   );
  }
}