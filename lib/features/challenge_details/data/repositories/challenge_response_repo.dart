import 'dart:developer';

import 'package:challenge_app/core/common/models/user_model.dart';
import 'package:challenge_app/features/challenge_details/data/data_sources/response_user_data_remote.dart';
import 'package:challenge_app/features/challenge_details/data/models/github_repository_model.dart';
import 'package:challenge_app/features/challenge_details/data/repositories/response_user_data_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error_handling/exceptions.dart';
import '../../../../../core/error_handling/failures.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../../../config/type_def.dart';
import '../data_sources/challenge_response_remote.dart';
import '../models/challenge_response_model.dart';

abstract class ChallengeResponseRepository{
  FutureEither<List<ChallengeResponseModel>> getChallengeResponds(String id);
  FutureEither<ChallengeResponseModel> getSpecificResponseData(String responseId);
  FutureEither<List<ChallengeResponseModel>> getFilteredChallengeResponds(String challengeId,List<String> filterIds);
  void reset();

  FutureEither<GithubRepositoryModel> getGithubRepositoryData(String repositoryId);
}

class ChallengeResponseRepositoryImpl implements ChallengeResponseRepository{
  final ChallengeResponseRemote _challengeResponseRemote;
  final ResponseUserDataRepository _responseUserDataRepository;
  final NetworkInfo _connectionChecker;
  const ChallengeResponseRepositoryImpl(this._challengeResponseRemote,this._responseUserDataRepository, this._connectionChecker);

  @override
  FutureEither<GithubRepositoryModel> getGithubRepositoryData(String repositoryId) async{
    if(await _connectionChecker.isConnected) {
      try{
        final results = await _challengeResponseRemote.getGithubRepositoryData(repositoryId);

        if(results.data() == null){
          throw NoDataFailure();
        }

        return Right(GithubRepositoryModel.fromMap(results.data()!));
      }catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }
    }else{
      return Left(NoInternetFailure());
    }
  }

  @override
  FutureEither<List<ChallengeResponseModel>> getChallengeResponds(String challengeId) async{
    if(await _connectionChecker.isConnected) {

      List<ChallengeResponseModel> responses = [];
      final QuerySnapshot<Map<String, dynamic>> results;

      try{
        results = await _challengeResponseRemote.getChallengeResponses(challengeId);
      } catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }

      await Future.forEach(results.docs, (element) async{
        ChallengeResponseModel responseModel = ChallengeResponseModel.fromMap(element.data());

        //add user data to response model
        final userData = await _responseUserDataRepository.getResponseUserData(responseModel.userId!);
        userData.fold(
          (failure){
            return;
          },
          (results){
            responseModel.userModel = results;
            responses.add(responseModel);
          }
        );
      });

      return Right(responses);

    }else{
      return Left(NoInternetFailure());
    }
  }

  FutureEither<List<ChallengeResponseModel>> getFilteredChallengeResponds(String challengeId,List<String> filterIds) async{
    if(await _connectionChecker.isConnected) {

      List<ChallengeResponseModel> responses = [];
      final QuerySnapshot<Map<String, dynamic>> results;

      try{
        results = await _challengeResponseRemote.getFilteredChallengeResponse(challengeId,filterIds);
      } catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }

      await Future.forEach(results.docs, (element) async{
        ChallengeResponseModel responseModel = ChallengeResponseModel.fromMap(element.data());

        //add user data to response model
        final userData = await _responseUserDataRepository.getResponseUserData(responseModel.userId!);
        userData.fold(
             (failure){
              return;
            },
             (results){
              responseModel.userModel = results;
              responses.add(responseModel);
            }
        );
      });

      return Right(responses);

    }else{
      return Left(NoInternetFailure());
    }
  }


  @override
  FutureEither<ChallengeResponseModel> getSpecificResponseData(String responseId) async{
    if(await _connectionChecker.isConnected) {

      final ChallengeResponseModel responseModel;

      try{
        final responseData = await _challengeResponseRemote.getSpecificResponseData(responseId);

        if(responseData.data() == null){
          throw NoDataFailure();
        }else{
          responseModel = ChallengeResponseModel.fromMap(responseData.data()!);
        }

        final userData = await _responseUserDataRepository.getResponseUserData(responseModel.userId!);
        userData.fold(
          (failure){
            return Left(failure);
          },
           (results){
            responseModel.userModel = results;
          }
        );

        return Right(responseModel);

      } catch(e){
        log(e.toString());
        return Left(ExceptionHandler.handle(e).failure);
      }

    }else{
      return Left(NoInternetFailure());
    }
  }

  @override
  void reset(){
    _challengeResponseRemote.reset();
  }

}