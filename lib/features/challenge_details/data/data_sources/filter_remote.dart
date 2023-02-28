import 'dart:developer';
import 'package:challenge_app/core/constants/end_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//const responsesFetchLimit = 6;

class FilterRemote{
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

 // DocumentSnapshot? lastChallengeResponse;

  Future<QuerySnapshot<Map<String, dynamic>>> getFilters() async{
   return await _fs.collection('categories').get();
  }

}