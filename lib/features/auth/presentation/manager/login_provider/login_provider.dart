import 'package:challenge_app/core/utils/network_checker.dart';
import 'package:challenge_app/features/auth/data/data_sources/auth_remote.dart';
import 'package:challenge_app/features/auth/data/data_sources/email_verification_remote.dart';
import 'package:challenge_app/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/email_verification_repo.dart';
part 'login_state.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginProvider,LoginState>(
  (ref){
    final networkInfo = NetworkInfo(InternetConnectionChecker());

    final authRemote = AuthRemote();
    final AuthRepository authRepository = AuthRepositoryImpl(authRemote,networkInfo);

    EmailVerificationRemote emailVerificationRemote = EmailVerificationRemote();
    EmailVerificationRepository emailVerificationRepository = EmailVerificationRepositoryImpl(
      emailVerificationRemote,networkInfo
    );

    return LoginProvider(authRepository,emailVerificationRepository);
   }
);

class LoginProvider extends StateNotifier<LoginState> {
  AuthRepository authRepository;
  EmailVerificationRepository emailVerificationRepository;

  LoginProvider(this.authRepository,this.emailVerificationRepository) : super(LoginInitial());

  Future login(String email,String password) async{
    state = LoginLoading();

    final results = await authRepository.loginWithEmail(
        email: email,
        password: password
    );

    await results.fold(
     (failure){
       state = LoginError(failure.message);
     },
     (_) async{
       final isEmailVerified = await emailVerificationRepository.isEmailVerified();

       isEmailVerified.fold((failure){
         state = LoginError(failure.message);
       }, (isVerified){
         state = LoginSuccess(isEmailVerified:isVerified);
       });

     });

  }

}
