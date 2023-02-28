import 'package:challenge_app/config/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/likes_manager_repo.dart';
part 'likes_manager_state.dart';

final likesManagerProvider = StateNotifierProvider<LikesManagerProvider,LikesManagerState>(
  (ref) => LikesManagerProvider(ref.read(likesManagerRepositoryProvider))
);

class LikesManagerProvider extends StateNotifier<LikesManagerState> {
  final LikesManagerRepository _likesManagerRepository;
  LikesManagerProvider(this._likesManagerRepository) : super(LikesManagerInitial());

  Future<void> addLike(String userId,String responseId) async{
    state = LikesManagerLoading();
    final results = await _likesManagerRepository.addLike(userId, responseId);

    results.fold(
      (failure){
        state = LikesManagerError(failure.message);
      },
      (results){
        state = LikesManagerDone();
      }
    );
  }

  Future<void> removeLike(String userId,String responseId) async{
    state = LikesManagerLoading();
    final results = await _likesManagerRepository.removeLike(userId, responseId);

    results.fold(
      (failure){
        state = LikesManagerError(failure.message);
      },
      (results){
        state = LikesManagerDone();
      }
    );
  }
}
