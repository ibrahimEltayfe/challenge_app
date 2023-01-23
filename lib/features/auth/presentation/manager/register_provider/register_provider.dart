import 'package:challenge_app/features/auth/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
part 'register_state.dart';

final registerProvider = StateNotifierProvider.autoDispose<RegisterProvider,RegisterState>(
  (ref) => RegisterProvider()
);

class RegisterProvider extends StateNotifier<RegisterState> {
  RegisterProvider() : super(RegisterInitial());

  Future register(UserModel userModel) async{

  }

}
