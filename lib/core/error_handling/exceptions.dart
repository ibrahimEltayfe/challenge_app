import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_errors.dart';
import 'failures.dart';
import 'fb_auth_errors.dart';

class ExceptionHandler implements Exception{
  late final Failure failure;


  ExceptionHandler.handle(dynamic e){
    if(e is FirebaseAuthException){
      failure = AuthFailure(FBAuthErrorMsgs.getEmailAuthErrorMsg(e.code));
    }else if(e is FirebaseException){
      failure = UnExpectedFailure(e.message??AppErrors.unKnownError);
    }else{
      failure = const UnExpectedFailure(AppErrors.unKnownError);
    }
  }

}
