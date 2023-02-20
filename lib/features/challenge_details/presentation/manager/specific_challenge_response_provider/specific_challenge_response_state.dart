part of 'specific_challenge_response_provider.dart';

abstract class SpecificChallengeResponseState extends Equatable {
  const SpecificChallengeResponseState();

  @override
  List<Object> get props => [];
}

class SpecificChallengeResponseInitial extends SpecificChallengeResponseState {}

class SpecificChallengeResponseLoading extends SpecificChallengeResponseState {}

class SpecificChallengeResponseDataFetched extends SpecificChallengeResponseState {}

class SpecificChallengeResponseError extends SpecificChallengeResponseState {
  final String message;
  const SpecificChallengeResponseError(this.message);

  @override
  List<Object> get props => [message];
}