import 'package:challenge_app/core/constants/end_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserBookmarksManagerRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<void> addToBookmarks({required String challengeId,required String userId}) async{
    await _fs.collection(EndPoints.users).doc(userId).update({
      "bookmarks" : FieldValue.arrayUnion([challengeId])
    });
  }

  Future<void> removeFromBookmarks({required String challengeId,required String userId}) async{
    await _fs.collection(EndPoints.users).doc(userId).update({
      "bookmarks" : FieldValue.arrayRemove([challengeId])
    });
  }
}