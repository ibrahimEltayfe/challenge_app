part of 'challenge_responses_provider.dart';

abstract class ChallengeResponseState extends Equatable {
  const ChallengeResponseState();

  @override
  List<Object> get props => [];
}

class ChallengeResponseInitial extends ChallengeResponseState {}

class ChallengeResponseLoading extends ChallengeResponseState {}

class ChallengeResponseDataFetched extends ChallengeResponseState {}

class ChallengeResponseError extends ChallengeResponseState {
  final String message;
  const ChallengeResponseError(this.message);

  @override
  List<Object> get props => [message];
}