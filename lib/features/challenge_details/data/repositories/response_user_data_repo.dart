import 'dart:developer';
import 'package:challenge_app/core/common/models/user_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../../../config/type_def.dart';
import '../data_sources/response_user_data_remote.dart';

abstract class ResponseUserDataRepository{
  FutureEither<UserModel> getResponseUserData(String uid);
}

class ResponseUserDataRepositoryImpl implements ResponseUserDataRepository{
  final ResponseUserDataRemote responseUserDataRemote;
  final NetworkInfo _connectionChecker;
  const ResponseUserDataRepositoryImpl(this.responseUserDataRemote, this._connectionChecker);

  @override
  FutureEither<UserModel> getResponseUserData(String uid) async{
    return await _handleFailures<UserModel>(() async{
      final userData = await responseUserDataRemote.getResponseUserData(uid);
      if(userData.data() == null){
        throw NoDataFailure();
      }

      return UserModel.fromMap(userData.data()!);
    });
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