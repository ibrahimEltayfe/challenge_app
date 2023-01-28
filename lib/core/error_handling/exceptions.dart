import 'dart:developer';
import 'dart:io' show FileSystemException;
import 'package:challenge_app/core/common/no_context_localization.dart';
import 'package:path_provider/path_provider.dart' show MissingPlatformDirectoryException;
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dio_errors.dart';
import 'failures.dart';
import 'fb_auth_errors.dart';

class ExceptionHandler implements Exception{
  late final Failure failure;

  ExceptionHandler.handle(dynamic e,{AuthMethod? authMethod}){
    if(e is FirebaseAuthException){
      if(authMethod == null){
        failure = UnExpectedFailure(e.message??noContextLocalization().unExpectedError);
      }else{
        failure = AuthFailure(authMethod.getAuthError(e.code));
      }
    }else if(e is FirebaseException){
      failure = UnExpectedFailure(e.message??noContextLocalization().unExpectedError);
    }else if(e is DioError){
      failure = handleDioErrors(e);
    } else if(e is MissingPlatformDirectoryException){
      failure = FileFailure(e.message);
    } else if(e is FileSystemException){
      failure = FileFailure(e.message);
    } else{
      failure = UnExpectedFailure(noContextLocalization().unExpectedError);
    }
  }
}


