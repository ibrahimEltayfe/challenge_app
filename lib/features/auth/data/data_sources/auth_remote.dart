import 'dart:developer';

import 'package:challenge_app/core/constants/end_points.dart';
import 'package:challenge_app/core/common/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemote {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login({required String email, required String password}) async {
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );

    //additional check, to handle if data did not initialized in register
    final bool isUserExists = await _isUserDataExists(userCredential.user!.uid);
    if(!isUserExists){
      await _initializeUserData(
          userCredential,
      );
    }
  }

  Future<void> register({required String email, required String password}) async {
    //register
    final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );

    await _initializeUserData(
       userCredential,
    );
  }

  //social logins
  Future<void> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    final bool isUserExists = await _isUserDataExists(userCredential.user!.uid);
    if(!isUserExists){
      await _initializeUserData(
          userCredential,
      );
    }

  }

  Future<bool> _isUserDataExists(String uid) async {
    final results = await _fs.collection(EndPoints.users).doc(uid).get();
    return results.data() != null;
  }

  Future<void> _initializeUserData(UserCredential userCredential) async{
    final UserModel userModel = UserModel();

    //user`s default values
    userModel.points = 0;
    userModel.title = '';
    userModel.bookmarks = [];
    userModel.challengeResponds = [];
    userModel.likes = [];

    //user`s data
    final user = userCredential.user!;
    final DateTime? creationDate = user.metadata.creationTime;

    userModel.email = user.email;
    userModel.name = user.displayName ?? '';
    userModel.uid = user.uid;
    userModel.createdTime = Timestamp.fromDate(creationDate??DateTime.now());
    userModel.image = user.photoURL ?? '';

    //save user`s data
    await _fs.collection(EndPoints.users).doc(user.uid).set(userModel.toMap());
  }

}