import 'dart:developer';

import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/features/challenge_details/data/models/github_repository_model.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
import '../../../data/models/challenge_response_model.dart';
import '../../../data/repositories/challenge_response_repo.dart';
part 'specific_challenge_response_state.dart';

final specificChallengeResponseProvider = StateNotifierProvider.autoDispose<SpecificChallengeResponseProvider,SpecificChallengeResponseState>(
  (ref){
    return SpecificChallengeResponseProvider(
       ref.read(challengeResponseRepositoryProvider)
    );
  }
);

class SpecificChallengeResponseProvider extends StateNotifier<SpecificChallengeResponseState> {
  final ChallengeResponseRepository _challengeResponseRepository;
  SpecificChallengeResponseProvider(this._challengeResponseRepository) : super(SpecificChallengeResponseInitial());

  late ChallengeResponseModel responseModel;
  late GithubRepositoryModel githubRepositoryModel;
  late String repositoryUrl;

  Future getResponseData(String responseId) async{
    state = SpecificChallengeResponseLoading();
    final results = await _challengeResponseRepository.getSpecificResponseData(responseId);

    results.fold(
        (failure){
          state = SpecificChallengeResponseError(failure.message);
        },
        (results) async{
          responseModel = results;
          await _getGithubRepositoryData(responseModel.githubRepositoryId!);
        }
    );
  }

  Future _getGithubRepositoryData(String repositoryId) async{
    final repositoryData = await _challengeResponseRepository.getGithubRepositoryData(repositoryId);

    repositoryData.fold(
        (failure){
          state = SpecificChallengeResponseError(failure.message);
        },
        (githubRepoModel){
          githubRepositoryModel = githubRepoModel;
          repositoryUrl = "https://github.com/${githubRepositoryModel.userName}/${githubRepositoryModel.repositoryName}/tree/${githubRepositoryModel.branchName}";
          state = SpecificChallengeResponseDataFetched();
        }
    );
  }
}

