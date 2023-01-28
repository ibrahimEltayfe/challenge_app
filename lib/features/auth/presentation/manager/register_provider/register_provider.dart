import 'package:challenge_app/core/utils/network_checker.dart';
import 'package:challenge_app/features/auth/data/data_sources/auth_remote.dart';
import 'package:challenge_app/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/data_sources/email_verification_remote.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/email_verification_repo.dart';
part 'register_state.dart';

final registerProvider = StateNotifierProvider.autoDispose<RegisterProvider,RegisterState>(
  (ref){
    final networkInfo = NetworkInfo(InternetConnectionChecker());
    final authRemote = AuthRemote();
    final AuthRepository authRepository = AuthRepositoryImpl(authRemote,networkInfo);

    return RegisterProvider(authRepository);
   }
);

class RegisterProvider extends StateNotifier<RegisterState> {
  AuthRepository authRepository;
  RegisterProvider(this.authRepository) : super(RegisterInitial());

  Future register(String email,String password) async{
    state = RegisterLoading();

    final results = await authRepository.register(
        email: email,
        password: password
    );

    results.fold(
     (failure){
       state = RegisterError(failure.message);
     },
     (_) {
       state = RegisterSuccess();
     });

  }

}
