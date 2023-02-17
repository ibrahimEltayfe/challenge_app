import 'dart:developer';
import 'package:challenge_app/config/type_def.dart';
import 'package:challenge_app/features/auth/data/data_sources/reset_password_remote.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../../../core/common/no_context_localization.dart';

abstract class ResetPasswordRepository{
  FutureEither<void> resetPassword(String email);
}

class ResetPasswordRepositoryImpl implements ResetPasswordRepository{
  final ResetPasswordRemote resetPasswordRemote;
  final NetworkInfo _connectionChecker;
  const ResetPasswordRepositoryImpl(this.resetPasswordRemote, this._connectionChecker);

  @override
  FutureEither<void> resetPassword(String email) async{
    return await _handleFailures(() => resetPasswordRemote.resetPassword(email));
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
      return Left(NoInternetFailure());
    }
  }

}