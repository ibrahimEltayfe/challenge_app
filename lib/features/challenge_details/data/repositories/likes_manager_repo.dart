import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../../../config/type_def.dart';
import '../data_sources/likes_manager_remote.dart';

abstract class LikesManagerRepository{
  FutureEither<Unit> addLike(String userId,String responseId);
  FutureEither<Unit> removeLike(String userId,String responseId);
}

class LikesManagerRepositoryImpl implements LikesManagerRepository{
  final LikesManagerRemote _likesManagerRemote;
  final NetworkInfo _connectionChecker;
  const LikesManagerRepositoryImpl(this._likesManagerRemote, this._connectionChecker);

  @override
  FutureEither<Unit> addLike(String userId, String responseId) async{
    return await _handleFailures((){
      return _likesManagerRemote.addLike(userId, responseId);
    });
  }

  @override
  FutureEither<Unit> removeLike(String userId, String responseId) async{
    return await _handleFailures((){
      return _likesManagerRemote.removeLike(userId, responseId);
    });
  }

  Future<Either<Failure, Unit>> _handleFailures(Future Function() task) async{
    if(await _connectionChecker.isConnected) {
      try{
        await task();
        return const Right(unit);
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return Left(NoInternetFailure());
    }
  }

}