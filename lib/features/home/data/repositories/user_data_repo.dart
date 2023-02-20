import 'dart:developer';
import 'package:challenge_app/config/type_def.dart';
import 'package:challenge_app/core/common/models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../data_sources/user_data_remote.dart';

abstract class UserDataRepository{
  FutureEither<UserModel> fetchUserData();
}

class UserDataRepositoryImpl implements UserDataRepository{
  final UserDataRemote userDataRemote;
  final NetworkInfo _connectionChecker;
  const UserDataRepositoryImpl(this.userDataRemote, this._connectionChecker);

  @override
  FutureEither<UserModel> fetchUserData() async{
    return await _handleFailures<UserModel>(() async{
      final userDoc = await userDataRemote.fetchUserData();

      if(!userDoc.exists || userDoc.data() == null){
        throw NoDataFailure();
      }

      return UserModel.fromMap(userDoc.data()!);
    },);
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