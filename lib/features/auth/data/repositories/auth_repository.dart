import 'dart:developer';
import 'package:challenge_app/core/common/no_context_localization.dart';
import 'package:challenge_app/core/error_handling/fb_auth_errors.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error_handling/exceptions.dart';
import '../../../../core/error_handling/failures.dart';
import '../../../../core/utils/network_checker.dart';
import '../data_sources/auth_remote.dart';

abstract class AuthRepository{
  Future<Either<Failure, Unit>> loginWithEmail({required String email, required String password});
  Future<Either<Failure, Unit>> register({required String email, required String password});
  Future<Either<Failure,Unit>> loginWithGoogle();
}

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemote authRemote;
  final NetworkInfo _connectionChecker;
  AuthRepositoryImpl(this.authRemote, this._connectionChecker);

  @override
  Future<Either<Failure, Unit>> loginWithEmail({required String email, required String password}) async{
    return await _handleFailures(
        AuthMethod.login,
        ()=> authRemote.login(email: email, password: password)
    );
  }

  @override
  Future<Either<Failure, Unit>> register({required String email, required String password}) async{
    return await _handleFailures(
      AuthMethod.register,
      ()=> authRemote.register(email: email, password: password)
    );
  }

  @override
  Future<Either<Failure,Unit>> loginWithGoogle() async{
    return await _handleFailures(
        AuthMethod.credential,
        ()=> authRemote.loginWithGoogle()
    );
  }

  Future<Either<Failure, Unit>> _handleFailures(AuthMethod authMethod, Future<void> Function() task) async{
      if(await _connectionChecker.isConnected) {
        try{
          await task();
          return const Right(unit);
        }catch(e){
          log(e.toString());
          return Left(ExceptionHandler.handle(e,authMethod: authMethod).failure);
        }
      }else{
        return Left(NoInternetFailure(noContextLocalization().noInternetError));
      }
  }

}