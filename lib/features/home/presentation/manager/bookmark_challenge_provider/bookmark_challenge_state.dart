part of 'bookmark_challenge_provider.dart';

abstract class BookmarkChallengeState extends Equatable {
  const BookmarkChallengeState();

  @override
  List<Object> get props => [];
}

class BookmarkChallengeInitial extends BookmarkChallengeState {}

class BookmarkChallengeLoading extends BookmarkChallengeState {}

class BookmarkChallengeAdded extends BookmarkChallengeState {}

class BookmarkChallengeRemoved extends BookmarkChallengeState {}

class BookmarkChallengeError extends BookmarkChallengeState {
  final String message;
  const BookmarkChallengeError(this.message);

  @override
  List<Object> get props => [message];
}