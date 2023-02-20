import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../../config/providers.dart';
import '../../../../../core/common/models/challenge_model.dart';
import '../../../data/data_sources/challenges_remote.dart' show docsFetchLimit;
import '../../../data/repositories/challenges_repo.dart';
part 'new_challenges_state.dart';

final newChallengesProvider = StateNotifierProvider<NewChallengesProvider,NewChallengesState>(
  (ref) => NewChallengesProvider(ref.read(challengeRepositoryProvider))..fetchChallenges()

);

class NewChallengesProvider extends StateNotifier<NewChallengesState> {
  final ChallengeRepository _challengeRepository;
  NewChallengesProvider(this._challengeRepository) : super(NewChallengesInitial());


  List<ChallengeModel> challengeModels = [];
  bool hasMore = true;

  Future<void> fetchChallenges() async{
    if(!hasMore){
      return;
    }

    state = NewChallengesLoading();
    final results = await _challengeRepository.fetchNewChallenges();

    results.fold(
        (failure){
          state = NewChallengesError(failure.message);
        },
       (results){
          if(results.length < docsFetchLimit){
            hasMore = false;
          }
          log('fetched');

          challengeModels.addAll(results);
          state = NewChallengesDataFetched();
        }
    );
  }

  bool handleScrollPagination(ScrollNotification scrollNotification, double subtractedTriggerHeight){
    if (scrollNotification.metrics.pixels
        >= scrollNotification.metrics.maxScrollExtent - subtractedTriggerHeight)
    {
      if (hasMore && (state != NewChallengesLoading())) {
         fetchChallenges();
      }
    }

    return true;
  }

  Future<void> refresh() async{
    hasMore = true;
    challengeModels = [];
    await fetchChallenges();
  }
}
