part of 'trendy_challenges_provider.dart';

abstract class TrendyChallengesState extends Equatable {
  const TrendyChallengesState();

  @override
  List<Object> get props => [];
}

class TrendyChallengesInitial extends TrendyChallengesState {}

class TrendyChallengesLoading extends TrendyChallengesState {}

class TrendyChallengesDataFetched extends TrendyChallengesState {}

class TrendyChallengesError extends TrendyChallengesState {
  final String message;
  const TrendyChallengesError(this.message);

  @override
  List<Object> get props => [message];
}