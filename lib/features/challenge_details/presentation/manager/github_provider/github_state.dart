part of 'github_provider.dart';

abstract class GithubState extends Equatable {
  const GithubState();

  @override
  List<Object> get props => [];
}

class GithubInitial extends GithubState {}

class GithubLoading extends GithubState {}

class GithubDataFetched extends GithubState {}

class GithubError extends GithubState {
  final String message;
  const GithubError(this.message);

  @override
  List<Object> get props => [message];
}