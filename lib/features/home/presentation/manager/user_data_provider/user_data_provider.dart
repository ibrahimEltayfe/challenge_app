import 'dart:developer';

import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/core/common/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/user_data_repo.dart';
part 'user_data_state.dart';

final userDataProvider = StateNotifierProvider<UserDataProvider,UserDataState>(
  (ref){
    return UserDataProvider(ref.read(userDataRepositoryProvider))..fetchUserData();
  }
);

class UserDataProvider extends StateNotifier<UserDataState> {
  final UserDataRepository userDataRepository;
  UserDataProvider(this.userDataRepository) : super(UserDataInitial());

  UserModel? userModel;

  Future<void> fetchUserData() async{
    state = UserDataLoading();

    final results = await userDataRepository.fetchUserData();

    results.fold(
      (failure){
        state = UserDataError(failure.message);
      },
      (model){
        userModel = model;
        state = UserDataFetched();
      }
    );

  }

  bool isBookmarked(String id){
    if(userModel == null){
      return false;
    }

    return userModel!.bookmarks!.contains(id);
  }

  void removeBookmarkFromModel(String challengeId){
    state = UserDataLoading();

    userModel!.bookmarks!.remove(challengeId);
    state = UserDataFetched();
  }

  void addBookmarkToModel(String challengeId){
    state = UserDataLoading();

    userModel!.bookmarks!.add(challengeId);
    state = UserDataFetched();
  }
}
