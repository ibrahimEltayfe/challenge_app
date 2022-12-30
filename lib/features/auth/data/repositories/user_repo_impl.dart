import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../core/constants/app_errors.dart';
import '../../../../core/error_handling/exceptions.dart';
import '../../../../core/error_handling/failures.dart';
import '../../../../core/utils/network_checker.dart';
import '../data_sources/firestore_auth_remote.dart';

abstract class UserRepository{
  Future<Either<Failure, Unit>> loginWithEmail({required String email, required String password});
  Future<Either<Failure, Unit>> logOut();

}

class UserRepositoryImpl implements UserRepository{
  final AuthRemote fireStoreAuthRemote;
  final NetworkInfo _connectionChecker;

  UserRepositoryImpl(this.fireStoreAuthRemote, this._connectionChecker);

  @override
  Future<Either<Failure, Unit>> loginWithEmail({required String email, required String password}) async{
    return await _handleFailures(
       ()=> fireStoreAuthRemote.signIn(email: email, password: password)
    );
  }

  @override
  Future<Either<Failure, Unit>> logOut() async{
    return await _handleFailures(
        ()=> fireStoreAuthRemote.logout()
    );
  }

  Future<Either<Failure, Unit>> _handleFailures(Future<void> Function() task) async{
        if(await _connectionChecker.isConnected) {
          try{
            await task();
            return const Right(unit);
          }catch(e){
            log(e.toString());
            return Left(ExceptionHandler.handle(e).failure);
          }
        }else{
          return const Left(NoInternetFailure(AppErrors.noInternet));
        }
  }

}