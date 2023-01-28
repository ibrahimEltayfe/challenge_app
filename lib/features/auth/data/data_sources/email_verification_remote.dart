import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/common/no_context_localization.dart';
import '../../../../core/error_handling/failures.dart';
import '../models/user_model.dart';

class EmailVerificationRemote{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> isEmailVerified() async{
    final user = _firebaseAuth.currentUser;

    if(user == null){
      throw NoUIDFailure(noContextLocalization().noUIDError);
    }

    await user.reload();
    return user.emailVerified;
  }


  Future<void> sendEmailVerification() async{
    //send email verification
    final user = _firebaseAuth.currentUser;

    if(user == null){
      throw NoUIDFailure(noContextLocalization().noUIDError);
    }

    await user.sendEmailVerification();
  }


}