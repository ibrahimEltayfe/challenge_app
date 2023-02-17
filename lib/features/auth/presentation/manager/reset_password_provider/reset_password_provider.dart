import 'package:challenge_app/config/providers.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';

import '../../../data/repositories/reset_password_repo.dart';
part 'reset_password_state.dart';

final resetPasswordProvider = StateNotifierProvider<ResetPasswordProvider,ResetPasswordState>(
  (ref) {
    return ResetPasswordProvider(ref.read(resetPasswordRepositoryProvider));
  }
);

class ResetPasswordProvider extends StateNotifier<ResetPasswordState> {
  final ResetPasswordRepository _resetPasswordRepository;
  ResetPasswordProvider(this._resetPasswordRepository) : super(ResetPasswordInitial());

  Future<void> resetPassword(String email) async{
    state = ResetPasswordLoading();

    final results = await _resetPasswordRepository.resetPassword(email);
    results.fold(
      (failure){
        state = ResetPasswordError(failure.message);
      },
      (results){
        state = ResetPasswordLinkSent();
      }
    );
  }
}
