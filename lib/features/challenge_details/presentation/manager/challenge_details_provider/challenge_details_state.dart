part of 'challenge_details_provider.dart';

abstract class ChallengeDetailsState extends Equatable {
  const ChallengeDetailsState();

  @override
  List<Object> get props => [];
}

class ChallengeDetailsInitial extends ChallengeDetailsState {}

class ChallengeDetailsLoading extends ChallengeDetailsState {}

class ChallengeDetailsDataFetched extends ChallengeDetailsState {}

class ChallengeDetailsError extends ChallengeDetailsState {
  final String message;
  const ChallengeDetailsError(this.message);

  @override
  List<Object> get props => [message];
}