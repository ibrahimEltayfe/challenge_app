import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/core/common/models/challenge_model.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/challenge_details_repo.dart';
part 'challenge_details_state.dart';

final challengeDetailsProvider = StateNotifierProvider.autoDispose<ChallengeDetailsProvider,ChallengeDetailsState>(
  (ref) => ChallengeDetailsProvider(ref.read(challengeDetailsRepositoryProvider))
);

class ChallengeDetailsProvider extends StateNotifier<ChallengeDetailsState> {
  final ChallengeDetailsRepository challengeDetailsRepository;
  ChallengeDetailsProvider(this.challengeDetailsRepository) : super(ChallengeDetailsInitial());

  late ChallengeModel challengeModel;

  Future<void> getChallengeDetails(String id) async{
    state = ChallengeDetailsLoading();
    final results = await challengeDetailsRepository.getChallengeDetails(id);

    results.fold(
      (failure){
        state = ChallengeDetailsError(failure.message);
      },
      (results){
        challengeModel = results;
        state = ChallengeDetailsDataFetched();
      }
    );
  }


}
