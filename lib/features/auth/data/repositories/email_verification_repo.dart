import 'dart:developer';
import 'package:challenge_app/features/auth/data/data_sources/email_verification_remote.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/no_context_localization.dart';
import '../../../../core/error_handling/exceptions.dart';
import '../../../../core/error_handling/failures.dart';
import '../../../../core/utils/network_checker.dart';

abstract class EmailVerificationRepository{
  Future<Either<Failure,bool>> isEmailVerified();
  Future<Either<Failure,void>> sendEmailVerification();
}

class EmailVerificationRepositoryImpl implements EmailVerificationRepository{
  final EmailVerificationRemote emailVerificationRemote;
  final NetworkInfo _connectionChecker;
  const EmailVerificationRepositoryImpl(this.emailVerificationRemote, this._connectionChecker);

  @override
  Future<Either<Failure,bool>> isEmailVerified() async{
    return await _handleFailures<bool>(() => emailVerificationRemote.isEmailVerified());
  }

  @override
  Future<Either<Failure,void>> sendEmailVerification() async{
    return await _handleFailures<void>(() => emailVerificationRemote.sendEmailVerification());
  }

  Future<Either<Failure, type>> _handleFailures<type>(Future<type> Function() task) async{
    if(await _connectionChecker.isConnected) {
      try{
        final type results = await task();
        return Right(results);
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return Left(NoInternetFailure(noContextLocalization().noInternetError));
    }
  }

}