import 'dart:io' show FileSystemException;
import 'package:challenge_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_errors.dart';
import 'dio_errors.dart';
import 'failures.dart';
import 'fb_auth_errors.dart';

class ExceptionHandler implements Exception{
  late final Failure failure;

  ExceptionHandler.handle(dynamic e){
    if(e is FirebaseAuthException){
      failure = AuthFailure(FBAuthErrorMsgs.getLoginErrorMessage(e.code));
    }else if(e is FirebaseException){
      failure = UnExpectedFailure(e.message??AppErrors.unKnownError);
    }else if(e is DioError){
      failure = handleDioErrors(e);
    } else if(e is MissingPlatformDirectoryException){
      failure = FileFailure(e.message);
    } else if(e is FileSystemException){
      failure = FileFailure(e.message);
    } else{
      failure = const UnExpectedFailure(AppErrors.unKnownError);
    }
  }
}
