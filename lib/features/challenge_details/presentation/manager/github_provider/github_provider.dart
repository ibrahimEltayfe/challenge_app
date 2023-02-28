import 'dart:developer';
import 'dart:io';
import 'package:challenge_app/config/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../data/models/github_repository_model.dart';
import '../../../data/repositories/github_repository.dart';
import '../specific_challenge_response_provider/specific_challenge_response_provider.dart';
part 'github_state.dart';


final githubProvider = StateNotifierProvider.autoDispose<GithubProvider,GithubState>(
  (ref){
    final repositoryModel = ref.watch(specificChallengeResponseProvider.notifier).githubRepositoryModel;
    final githubRepositoryRef = ref.read(githubRepositoryProvider);
    return GithubProvider(githubRepositoryRef)..downloadRepository(repositoryModel);
 }
);

class GithubProvider extends StateNotifier<GithubState> {
  final GithubRepository _githubRepository;
  GithubProvider(this._githubRepository) : super(GithubInitial());

  Future<void> downloadRepository(GithubRepositoryModel githubRepository) async{
    state = GithubLoading();

    bool localRepoDirectory = await _isRepositoryExistsLocally(githubRepository);

    if(!localRepoDirectory){
      final results = await _githubRepository.downloadAndUnZipRepository(githubRepository);
      results.fold(
          (failure){
            state = GithubError(failure.message);
          },
          (_){
            state = GithubDataFetched();
          }
      );
    }else{
      state = GithubDataFetched();
    }

  }

  Future<bool> _isRepositoryExistsLocally(GithubRepositoryModel githubRepository) async{
    final dir = await getApplicationDocumentsDirectory();
    Directory repoLocalDirectory = Directory(
        path.join(
            dir.path,
            'out/${githubRepository.repositoryName}-${githubRepository.branchName}'
        )
    );

    return repoLocalDirectory.existsSync();
  }
}
