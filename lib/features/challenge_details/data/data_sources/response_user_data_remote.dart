import 'package:challenge_app/core/constants/end_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseUserDataRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getResponseUserData(String userId) async{
    return await _fs.collection(EndPoints.users).doc(userId).get();
  }

}