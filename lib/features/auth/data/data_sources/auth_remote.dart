import 'package:challenge_app/core/constants/end_points.dart';
import 'package:challenge_app/features/auth/data/models/user_model.dart';
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
          isVerified: false
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
        isVerified: false
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
          isVerified: true
      );
    }

  }

  Future<bool> _isUserDataExists(String uid) async {
    final results = await _fs.collection(EndPoints.users).doc(uid).get();
    return results.data() == null;
  }

  Future<void> _initializeUserData(UserCredential userCredential,{required bool isVerified}) async{
    final UserModel userModel = UserModel().initialize();

    final user = userCredential.user!;

    //set user fields
    final DateTime? creationDate = user.metadata.creationTime;

    userModel.email = user.email;
    userModel.name = user.displayName ?? '';
    userModel.isVerified = isVerified;
    userModel.uid = user.uid;
    userModel.createdTime = Timestamp.fromDate(creationDate??DateTime.now());
    userModel.image = user.photoURL ?? '';

    //save user`s data
    await _fs.collection(EndPoints.users).doc(user.uid).set(userModel.toMap());
  }

}