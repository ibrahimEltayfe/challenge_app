import 'package:challenge_app/core/utils/network_checker.dart';
import 'package:challenge_app/features/auth/data/data_sources/auth_remote.dart';
import 'package:challenge_app/features/auth/data/data_sources/email_verification_remote.dart';
import 'package:challenge_app/core/common/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/email_verification_repo.dart';
part 'social_login_state.dart';

final socialLoginProvider = StateNotifierProvider.autoDispose<SocialLoginProvider,SocialLoginState>(
  (ref){
    final networkInfo = NetworkInfo(InternetConnectionChecker());

    final authRemote = AuthRemote();
    final AuthRepository authRepository = AuthRepositoryImpl(authRemote,networkInfo);

    return SocialLoginProvider(authRepository);
   }
);

class SocialLoginProvider extends StateNotifier<SocialLoginState> {
  AuthRepository authRepository;

  SocialLoginProvider(this.authRepository) : super(SocialLoginInitial());

  Future loginWithGoogle() async{
    state = SocialLoginLoading();

    final results = await authRepository.loginWithGoogle();

    results.fold(
     (failure){
       state = SocialLoginError(failure.message);
     },
     (_) {
       state = SocialLoginSuccess();
     });

  }

}
