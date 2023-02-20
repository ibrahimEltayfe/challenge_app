import 'package:challenge_app/core/common/no_context_localization.dart';
import 'package:challenge_app/core/constants/end_points.dart';
import 'package:challenge_app/core/error_handling/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataRemote{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchUserData() async{
    final currentUser = _firebaseAuth.currentUser;

    if(currentUser == null){
      throw NoUIDFailure();
    }

    return await _fs.collection(EndPoints.users).doc(currentUser.uid).get();
  }


}