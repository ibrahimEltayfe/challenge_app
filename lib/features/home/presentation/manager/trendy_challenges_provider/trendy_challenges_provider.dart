import 'dart:developer';

import 'package:challenge_app/config/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/data_sources/challenges_remote.dart' show docsFetchLimit;
import '../../../../../core/common/models/challenge_model.dart';

import '../../../data/repositories/challenges_repo.dart';
part 'trendy_challenges_state.dart';

final trendyChallengesProvider = StateNotifierProvider<TrendyChallengesProvider,TrendyChallengesState>(
  (ref){
    return TrendyChallengesProvider(ref.read(challengeRepositoryProvider))..fetchChallenges();
  }
);

class TrendyChallengesProvider extends StateNotifier<TrendyChallengesState> {
  final ChallengeRepository _challengeRepository;
  TrendyChallengesProvider(this._challengeRepository) : super(TrendyChallengesInitial());

  List<ChallengeModel> challengeModels = [];
  bool hasMore = true;

  Future<void> fetchChallenges() async{
    if(!hasMore){
      return;
    }

    state = TrendyChallengesLoading();
    final results = await _challengeRepository.fetchTrendyChallenges();

    results.fold(
      (failure){
        state = TrendyChallengesError(failure.message);
      },
      (results){
        if(results.length < docsFetchLimit){
          hasMore = false;
        }
        log('fetched');

        challengeModels.addAll(results);
        state = TrendyChallengesDataFetched();
      }
    );
  }

  bool handleScrollPagination(ScrollNotification scrollNotification, double trigger){
    if (scrollNotification.metrics.pixels
        >= scrollNotification.metrics.maxScrollExtent - trigger) {
      if (hasMore) {
        if(state != TrendyChallengesLoading()){
          fetchChallenges();
        }
      }
      return true;
    }
    return false;
  }

  Future<void> refresh() async{
    hasMore = true;
    challengeModels = [];
    await fetchChallenges();
  }

}
