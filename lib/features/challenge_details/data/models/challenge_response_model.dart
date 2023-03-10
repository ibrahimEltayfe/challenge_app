import '../../../../core/common/models/user_model.dart';

class ChallengeResponseModel{
  final String? challengeId;
  final List<dynamic>? categoryIds;
  final String? id;
  final int? numOfLikes;
  final List<dynamic>? media;
  final String? githubRepositoryId;
  final String? userId;
  UserModel? userModel;

  ChallengeResponseModel({
    required this.challengeId,
    required this.categoryIds,
    required this.id,
    required this.numOfLikes,
    required this.media,
    required this.githubRepositoryId,
    required this.userId,
    this.userModel
  });

  Map<String, dynamic> toMap() {
    return {
      if(challengeId != null) 'challengeId': challengeId,
      if(categoryIds != null) 'categoryIds': categoryIds,
      if(id != null) 'id': id,
      if(numOfLikes != null) 'numOfLikes':numOfLikes,
      if(media != null) 'media': media,
      if(githubRepositoryId != null) 'githubRepositoryId': githubRepositoryId!,
      if(userId != null) 'userId': userId,
    };
  }

  factory ChallengeResponseModel.fromMap(Map<String,dynamic> data) {
    return ChallengeResponseModel(
      challengeId: data['challengeId'] ?? '',
      categoryIds: data['categoryIds'] ?? [],
      id: data['id'] ?? '',
      numOfLikes: (data['numOfLikes']??0).toInt(),
      media: data['media'] ?? [],
      githubRepositoryId: data['githubRepositoryId'] ?? '',
      userId: data['userId'] ?? '',
    );
  }
}