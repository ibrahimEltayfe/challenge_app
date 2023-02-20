import 'dart:developer';
import 'package:challenge_app/config/type_def.dart';
import '../../../../../core/common/models/challenge_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../data_sources/challenge_details_remote.dart';
import '../models/challenge_response_model.dart';

abstract class ChallengeDetailsRepository{
  FutureEither<ChallengeModel> getChallengeDetails(String id);
}

class ChallengeDetailsRepositoryImpl implements ChallengeDetailsRepository{
  final ChallengeDetailsRemote challengeDetailsRemote;
  final NetworkInfo _connectionChecker;
  const ChallengeDetailsRepositoryImpl(this.challengeDetailsRemote, this._connectionChecker);

  @override
  FutureEither<ChallengeModel> getChallengeDetails(String id) async{
    return await _handleFailures<ChallengeModel>(() async{
      final results = await challengeDetailsRemote.getChallengeDetails(id);
      final challengeData = results.data();

      if(challengeData != null){
        return ChallengeModel.fromMap(challengeData);
      }else {
        throw NoDataFailure();
      }
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