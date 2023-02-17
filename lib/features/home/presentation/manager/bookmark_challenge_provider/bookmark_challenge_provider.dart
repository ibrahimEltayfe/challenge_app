import 'package:challenge_app/config/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/user_bookmarks_manager_repo.dart';
part 'bookmark_challenge_state.dart';

final bookmarkChallengeProvider = StateNotifierProvider<BookmarkChallengeProvider,BookmarkChallengeState>(
  (ref) => BookmarkChallengeProvider(ref.read(userBookmarksManagerRepositoryProvider))
);

class BookmarkChallengeProvider extends StateNotifier<BookmarkChallengeState> {
  final UserBookmarksManagerRepository bookmarksManagerRepository;
  BookmarkChallengeProvider(this.bookmarksManagerRepository) : super(BookmarkChallengeInitial());

  Future<void> addToBookmarks({required String challengeId,required String userId}) async{
    state = BookmarkChallengeLoading();

    final results = await bookmarksManagerRepository.addToBookmarks(challengeId: challengeId, userId: userId);

    results.fold(
      (failure){
        state = BookmarkChallengeError(failure.message);
      },
      (results){
        state = BookmarkChallengeAdded();
      }
    );
  }

  Future<void> removeFromBookmarks({required String challengeId,required String userId}) async{
    state = BookmarkChallengeLoading();
    final results = await bookmarksManagerRepository.removeFromBookmarks(challengeId: challengeId, userId: userId);

    results.fold(
        (failure){
          state = BookmarkChallengeError(failure.message);
        },
        (results){
          state = BookmarkChallengeRemoved();
        }
    );
  }

}
