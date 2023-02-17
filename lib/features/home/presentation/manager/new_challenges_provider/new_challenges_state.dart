part of 'new_challenges_provider.dart';

abstract class NewChallengesState extends Equatable {
  const NewChallengesState();

  @override
  List<Object> get props => [];
}

class NewChallengesInitial extends NewChallengesState {}

class NewChallengesLoading extends NewChallengesState {}

class NewChallengesDataFetched extends NewChallengesState {}

class NewChallengesError extends NewChallengesState {
  final String message;
  const NewChallengesError(this.message);

  @override
  List<Object> get props => [message];
}