import 'dart:developer';
import 'package:challenge_app/core/common/no_context_localization.dart';
import 'package:challenge_app/core/constants/end_points.dart';
import 'package:challenge_app/core/error_handling/failures.dart';
import 'package:challenge_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemote {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );

    if(userCredential.user == null){
      throw NoUIDFailure(noContextLocalization().noUIDError);
    }

    //additional check, to handle if data did not initialized in register
    final checkIfUserDataExists = await _fs.collection(EndPoints.users).doc(userCredential.user!.uid).get();
    if(checkIfUserDataExists.data() == null){
      await initializeUserData();
    }
  }

  Future<void> register({required String email, required String password}) async {
    //register
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    await initializeUserData();
  }

  Future<void> initializeUserData() async{
    final UserModel userModel = UserModel().initialize();

    final user = _firebaseAuth.currentUser!;

    //set user fields
    final DateTime? creationDate = user.metadata.creationTime;

    userModel.email = user.email;
    userModel.name = user.email!.split('@').first;
    userModel.isVerified = user.emailVerified;
    userModel.uid = user.uid;
    userModel.createdTime = Timestamp.fromDate(creationDate??DateTime.now());

    //save user`s data
    await _fs.collection(EndPoints.users).doc(user.uid).set(userModel.toMap());
  }

  Future checkIsEmailVerified() async{
    final user = _firebaseAuth.currentUser;

    if(user == null){
      throw NoUIDFailure(noContextLocalization().noUIDError);
    }

    await user.reload();
    return user.emailVerified;
  }



}