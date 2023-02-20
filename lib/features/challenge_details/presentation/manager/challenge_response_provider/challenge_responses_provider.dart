import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/features/challenge_details/data/data_sources/challenge_response_remote.dart' show responsesFetchLimit;
import 'package:challenge_app/features/challenge_details/data/models/challenge_response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/challenge_response_repo.dart';
part 'challenge_responses_state.dart';

final challengeResponseProvider = StateNotifierProvider.autoDispose.family<ChallengeResponseProvider,ChallengeResponseState,String>(
  (ref,id) => ChallengeResponseProvider(ref.read(challengeResponseRepositoryProvider))..getChallengeResponses(id)
);

class ChallengeResponseProvider extends StateNotifier<ChallengeResponseState> {
  final ChallengeResponseRepository _challengeResponseRepository;
  ChallengeResponseProvider(this._challengeResponseRepository) : super(ChallengeResponseInitial());

  List<ChallengeResponseModel> responses = [];

  bool hasMore = true;

  Future getChallengeResponses(String challengeId) async{
    if(!hasMore){
      return;
    }

    state = ChallengeResponseLoading();
    final results = await _challengeResponseRepository.getChallengeResponds(challengeId);

    results.fold(
      (failure){
        state = ChallengeResponseError(failure.message);
      },
      (results){
        if(results.length < responsesFetchLimit){
          hasMore = false;
        }

        responses.addAll(results);

        state = ChallengeResponseDataFetched();
      }
    );
  }
}
