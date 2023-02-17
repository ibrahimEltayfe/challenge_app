part of 'regular_challenges_provider.dart';

abstract class RegularChallengesState extends Equatable {
  const RegularChallengesState();

  @override
  List<Object> get props => [];
}

class RegularChallengesInitial extends RegularChallengesState {}

class RegularChallengesLoading extends RegularChallengesState {}

class RegularChallengesDataFetched extends RegularChallengesState {}

class RegularChallengesError extends RegularChallengesState {
  final String message;
  const RegularChallengesError(this.message);

  @override
  List<Object> get props => [message];
}