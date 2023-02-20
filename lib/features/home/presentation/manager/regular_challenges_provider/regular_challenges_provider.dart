import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../../config/providers.dart';
import '../../../data/data_sources/challenges_remote.dart' show docsFetchLimit;
import '../../../../../core/common/models/challenge_model.dart';
import '../../../data/repositories/challenges_repo.dart';
part 'regular_challenges_state.dart';

final regularChallengesProvider = StateNotifierProvider<RegularChallengesProvider,RegularChallengesState>(
  (ref) => RegularChallengesProvider(ref.read(challengeRepositoryProvider))..fetchChallenges()
);

class RegularChallengesProvider extends StateNotifier<RegularChallengesState> {
  final ChallengeRepository _challengeRepository;
  RegularChallengesProvider(this._challengeRepository) : super(RegularChallengesInitial());

  List<ChallengeModel> challengeModels = [];
  bool hasMore = true;

  Future<void> fetchChallenges() async{
    if(!hasMore){
      return;
    }

    state = RegularChallengesLoading();
    final results = await _challengeRepository.fetchRegularChallenges();

    results.fold(
        (failure){
          state = RegularChallengesError(failure.message);
        },
         (results){
          if(results.length < docsFetchLimit){
            hasMore = false;
          }
          log('fetched');

          challengeModels.addAll(results);
          state = RegularChallengesDataFetched();
        }
    );
  }

  bool handleScrollPagination(ScrollNotification scrollNotification, double trigger){
    if (scrollNotification.metrics.pixels
        >= scrollNotification.metrics.maxScrollExtent - trigger) {
      if (hasMore) {
        if(state != RegularChallengesLoading()){
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
