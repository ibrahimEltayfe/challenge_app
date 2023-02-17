import 'dart:developer';
import 'package:challenge_app/config/type_def.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../data_sources/user_bookmarks_manager_remote.dart';

abstract class UserBookmarksManagerRepository{
  FutureEither<Unit> addToBookmarks({required String challengeId,required String userId});
  FutureEither<Unit> removeFromBookmarks({required String challengeId,required String userId});
}

class UserBookmarksManagerRepositoryImpl implements UserBookmarksManagerRepository{
  final UserBookmarksManagerRemote userBookmarksManagerRemote;
  final NetworkInfo _connectionChecker;
  const UserBookmarksManagerRepositoryImpl(this.userBookmarksManagerRemote, this._connectionChecker);

  @override
  FutureEither<Unit> addToBookmarks({required String challengeId,required String userId}) async{
    return await _handleFailures(() => userBookmarksManagerRemote.addToBookmarks(
        challengeId: challengeId,
        userId: userId
    ));
  }

  @override
  FutureEither<Unit> removeFromBookmarks({required String challengeId,required String userId}) async{
    return await _handleFailures(() => userBookmarksManagerRemote.removeFromBookmarks(
        challengeId: challengeId,
        userId: userId
    ));
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