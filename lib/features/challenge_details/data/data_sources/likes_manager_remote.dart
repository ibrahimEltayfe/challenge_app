import 'package:challenge_app/core/constants/end_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikesManagerRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

 Future<void> addLike(String userId,String responseId) async{
   await _fs.runTransaction((transaction) async{
     await _fs.collection(EndPoints.users).doc(userId).update({
       "likes" : FieldValue.arrayUnion([responseId])
     });

     await _fs.collection(EndPoints.challengeResponds).doc(responseId).update({
       "numOfLikes" : FieldValue.increment(1)
     });
   });
 }

 Future<void> removeLike(String userId,String responseId) async{
   await _fs.runTransaction((transaction) async{
     await _fs.collection(EndPoints.users).doc(userId).update({
       "likes" : FieldValue.arrayRemove([responseId])
     });

     await _fs.collection(EndPoints.challengeResponds).doc(responseId).update({
       "numOfLikes" : FieldValue.increment(-1)
     });
   });
 }
}