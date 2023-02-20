import 'package:challenge_app/core/constants/end_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeDetailsRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getChallengeDetails(String id) async{
    final results = await  _fs.collection(EndPoints.challenges).doc(id).get();
    return results;
  }

}