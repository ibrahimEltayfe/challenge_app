part of 'likes_manager_provider.dart';

abstract class LikesManagerState extends Equatable {
  const LikesManagerState();

  @override
  List<Object> get props => [];
}

class LikesManagerInitial extends LikesManagerState {}

class LikesManagerLoading extends LikesManagerState {}

class LikesManagerDone extends LikesManagerState {}

class LikesManagerError extends LikesManagerState {
  final String message;
  const LikesManagerError(this.message);

  @override
  List<Object> get props => [message];
}