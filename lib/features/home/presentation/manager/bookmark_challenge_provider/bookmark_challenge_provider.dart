import 'dart:developer';

import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/features/home/presentation/manager/user_data_provider/user_data_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/user_bookmarks_manager_repo.dart';
part 'bookmark_challenge_state.dart';

final bookmarkChallengeProvider = StateNotifierProvider<BookmarkChallengeProvider,BookmarkChallengeState>(
  (ref) => BookmarkChallengeProvider(ref.read(userBookmarksManagerRepositoryProvider),ref)
);

class BookmarkChallengeProvider extends StateNotifier<BookmarkChallengeState> {
  final UserBookmarksManagerRepository bookmarksManagerRepository;
  final StateNotifierProviderRef _ref;
  BookmarkChallengeProvider(this.bookmarksManagerRepository,this._ref) : super(BookmarkChallengeInitial());

  Future<void> addToBookmarks({required String challengeId,required String userId}) async{
    state = BookmarkChallengeLoading();

    final results = await bookmarksManagerRepository.addToBookmarks(challengeId: challengeId, userId: userId);

    results.fold(
      (failure){
        state = BookmarkChallengeError(failure.message);
      },
      (results){
        _ref.watch(userDataProvider.notifier).addBookmarkToModel(challengeId);
        state = BookmarkChallengeAdded(challengeId);
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
          _ref.watch(userDataProvider.notifier).removeBookmarkFromModel(challengeId);
          state = BookmarkChallengeRemoved(challengeId);
        }
    );
  }

}
