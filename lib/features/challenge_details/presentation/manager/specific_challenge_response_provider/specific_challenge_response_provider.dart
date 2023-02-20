import 'package:challenge_app/config/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
import '../../../data/models/challenge_response_model.dart';
import '../../../data/repositories/challenge_response_repo.dart';
part 'specific_challenge_response_state.dart';

final specificChallengeResponseProvider = StateNotifierProvider.autoDispose.family<SpecificChallengeResponseProvider,SpecificChallengeResponseState,String>(
  (ref,responseId) => SpecificChallengeResponseProvider(ref.read(challengeResponseRepositoryProvider))..getResponseData(responseId)
);

class SpecificChallengeResponseProvider extends StateNotifier<SpecificChallengeResponseState> {
  final ChallengeResponseRepository _challengeResponseRepository;
  SpecificChallengeResponseProvider(this._challengeResponseRepository) : super(SpecificChallengeResponseInitial());

  late ChallengeResponseModel responseModel;

  Future getResponseData(String responseId) async{
    state = SpecificChallengeResponseLoading();
    final results = await _challengeResponseRepository.getSpecificResponseData(responseId);

    results.fold(
        (failure){
          state = SpecificChallengeResponseError(failure.message);
        },
        (results){
          responseModel = results;
          state = SpecificChallengeResponseDataFetched();
        }
    );
  }
}

