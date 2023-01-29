import 'dart:async';

import 'package:challenge_app/core/common/no_context_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod/riverpod.dart';
import '../../../../../core/utils/network_checker.dart';
import '../../../data/data_sources/email_verification_remote.dart';
import '../../../data/repositories/email_verification_repo.dart';
part 'check_email_verification_state.dart';

final checkEmailVerificationProvider = StateNotifierProvider.autoDispose<CheckEmailVerificationProvider,CheckEmailVerificationState>(
  (ref){
    final networkInfo = NetworkInfo(InternetConnectionChecker());
    EmailVerificationRemote emailVerificationRemote = EmailVerificationRemote();
    EmailVerificationRepository emailVerificationRepository = EmailVerificationRepositoryImpl(
        emailVerificationRemote,networkInfo
    );
    return CheckEmailVerificationProvider(emailVerificationRepository);
  }
);

class CheckEmailVerificationProvider extends StateNotifier<CheckEmailVerificationState> {
  EmailVerificationRepository emailVerificationRepository;
  CheckEmailVerificationProvider(this.emailVerificationRepository) : super(CheckEmailVerificationInitial());

  Future<void> isEmailVerified() async{
    state = CheckEmailVerificationLoading();

    final results = await emailVerificationRepository.isEmailVerified();

    results.fold(
      (failure){
        state = CheckEmailVerificationError(failure.message);
      },
      (isVerified){
        if(isVerified){
          state = CheckEmailVerifiedSuccessfully();
        }else{
          state = CheckEmailVerificationError(noContextLocalization().emailNotVerified);
        }
      }
    );
  }
  
}
