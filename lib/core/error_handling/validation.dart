import 'package:challenge_app/core/common/no_context_localization.dart';
import 'package:email_validator/email_validator.dart';

class Validation {
  String? emailValidator(String? email){
    if(email == null || email.isEmpty) {
      return noContextLocalization().emailIsEmptyError.toString();
    }else if(!EmailValidator.validate(email)){
        return noContextLocalization().invalidEmail;
    }

    return null;
  }

  String? registerPasswordValidator(String? password){

    if(password == null || password.isEmpty) {
      return noContextLocalization().passwordIsEmptyError;
    }else if(password.length < 6) {
      return noContextLocalization().passwordLengthError;
    }
    return null;
  }

  String? nameValidator(String? name){

    if(name == null || name.isEmpty) {
      return noContextLocalization().nameIsEmptyError;
    }else if(name.length>=20) {
      return noContextLocalization().nameLengthError;
    }
    return null;
  }

  String? loginPasswordValidator(String? password){

    if(password == null || password.isEmpty){
      return noContextLocalization().passwordIsEmptyError;
    }

    return null;
  }
}
