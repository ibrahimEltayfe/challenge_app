import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
part 'challenge_details_state.dart';

final challengeDetailsProvider = StateNotifierProvider<ChallengeDetailsProvider,ChallengeDetailsState>(
  (ref) => ChallengeDetailsProvider()
);

class ChallengeDetailsProvider extends StateNotifier<ChallengeDetailsState> {
  ChallengeDetailsProvider() : super(ChallengeDetailsInitial());
}
