import 'dart:developer';
import 'package:challenge_app/config/type_def.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../data_sources/challenge_remote.dart';
import '../models/challenge_model.dart';

abstract class ChallengeRepository{
  FutureEither<List<ChallengeModel>> fetchTrendyChallenges();
  FutureEither<List<ChallengeModel>> fetchNewChallenges();
  FutureEither<List<ChallengeModel>> fetchRegularChallenges();
  void resetPagination();
}

class ChallengeRepositoryImpl implements ChallengeRepository{
  final ChallengeRemote challengeDataRemote;
  final NetworkInfo _connectionChecker;
  const ChallengeRepositoryImpl(this.challengeDataRemote, this._connectionChecker);

  @override
  FutureEither<List<ChallengeModel>> fetchNewChallenges() async{
    return await _handleFailures((){
      return challengeDataRemote.fetchNewChallenges();
    });
  }

  @override
  FutureEither<List<ChallengeModel>> fetchRegularChallenges() async{
    return await _handleFailures((){
      return challengeDataRemote.fetchRegularChallenges();
    });
  }

  @override
  FutureEither<List<ChallengeModel>> fetchTrendyChallenges() async{
    return await _handleFailures((){
      return challengeDataRemote.fetchTrendyChallenges();
    });
  }

  @override
  void resetPagination() {
    challengeDataRemote.resetPagination();
  }

  Future<Either<Failure, List<ChallengeModel>>> _handleFailures<type>(Future<QuerySnapshot<Map<String, dynamic>>> Function() task) async{
    if(await _connectionChecker.isConnected) {
      try{
        final QuerySnapshot<Map<String, dynamic>> results = await task();
        List<ChallengeModel> challengeModels = [];

        for(var doc in results.docs){
          if(doc.data().isNotEmpty){
            challengeModels.add(ChallengeModel.fromMap(doc.data()));
          }
        }

        return Right(challengeModels);
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return Left(NoInternetFailure());
    }
  }


}