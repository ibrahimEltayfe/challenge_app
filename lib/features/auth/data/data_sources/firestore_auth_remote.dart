import 'package:challenge_app/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemote {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signIn({required String email, required String password}) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> register(
      {required UserModel userModel, required String password}) async {
    await _fs.runTransaction((transaction) async {
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(
          email: userModel.email!,
          password: password
      );
    });
  }
}
  /* if(userCredential.user == null){
      throw NoUIDFailure(message)
     }/*


  }


   final userDoc = _fs.collection(EndPoints.users).doc(userCredential.user!.uid);
   userDoc.add(data)
   
   await userCredential.user!.sendEmailVerification();
 }

    //final DateTime? creationDate = currentUser.user!.metadata.creationTime;
   */
   */
   //final Timestamp timeStamp = Timestamp.fromDate(creationDate!);
/*
 Future<void> _addData({required Map<String,dynamic> data}) async{
   return await _fs.collection(EndPoints.users).doc(data['uid'])
       .set(data);
 }
*/