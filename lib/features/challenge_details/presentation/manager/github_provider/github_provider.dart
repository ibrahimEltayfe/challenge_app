import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/utils/github_helper.dart';
import 'package:path/path.dart' as path;
part 'github_state.dart';


final githubProvider = StateNotifierProvider.autoDispose<GithubProvider,GithubState>(
  (ref){
    final githubRef = ref.read(githubHelperProvider);
    return GithubProvider(githubRef)..downloadRepository(GithubRepository(
        repositoryName: 'weather-app',
        branchName: 'main',
        userName: 'ibrahimEltayfe'
    ));
 }
);

class GithubProvider extends StateNotifier<GithubState> {
  final GithubHelper githubHelper;
  GithubProvider(this.githubHelper) : super(GithubInitial());

  Future<void> downloadRepository(GithubRepository githubRepository) async{
    state = GithubLoading();

    bool localRepoDirectory = await _isRepositoryExistsLocally(githubRepository);

    if(!localRepoDirectory){
      final results = await githubHelper.downloadAndUnZipRepository(githubRepository);
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

  Future<bool> _isRepositoryExistsLocally(GithubRepository githubRepository) async{
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
