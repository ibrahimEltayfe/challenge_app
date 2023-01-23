import 'package:challenge_app/core/common/no_context_localization.dart';

class FBAuthErrorMsgs {

  static String getLoginErrorMessage(String code) {
    final localization = noContextLocalization();

    switch (code) {
      case 'user-disabled':
        return localization.userDisabled;
      case 'user-not-found':
        return localization.userNotFound;
      case 'wrong-password':
        return localization.wrongPassword;
      case 'invalid-email':
        return localization.invalidEmail;
      default:
        return localization.loginDefaultError;
    }
  }

  static String getRegisterErrorMessage(String code){
    final localization = noContextLocalization();

    switch (code) {
      case 'error_operation_not_allowed':
        return localization.errorOperationNotAllowed;
      case 'error_weak_password':
        return localization.errorWeakPassword;
      case 'error_invalid_email':
        return localization.errorInvalidEmail;
      case 'error_email_already_in_use':
        return localization.errorEmailAlreadyInUse;
      case 'error_invalid_credential':
        return localization.errorInvalidCredential;
      default:
        return localization.registerDefaultError;
    }
}

  static String getCredentialErrorMessage(String code) {
    final localization = noContextLocalization();

    switch (code) {
      case 'account-exists-with-different-credential':
        return localization.accountExistsWithDifferentCredential;
      case 'invalid-credential':
        return localization.invalidCredential;
      case 'operation-not-allowed':
        return localization.operationNotAllowed;
      case 'user-disabled':
        return localization.userDisabled;
      case 'user-not-found':
        return localization.userNotFound;
      case 'wrong-password':
        return localization.wrongPassword;
      case 'invalid-verification-code':
        return localization.invalidVerificationCode;
      case 'invalid-verification-id':
        return localization.invalidVerificationId;
      default:
        return localization.credentialDefaultError;
    }
  }

  static getResetPasswordErrorMessage(String code){
    final localization = noContextLocalization();

    switch (code) {
      case 'expired_action_code':
        return localization.expiredActionCode;
      case 'invalid_action_code':
        return localization.invalidActionCode;
      case 'user_disabled':
        return localization.userDisabled;
      case 'user_not_found':
        return localization.userNotFound;
      case 'weak_password':
        return localization.weakPassword;
      default:
        return localization.resetPasswordDefaultError;
    }
  }

  static getResetPasswordEmailErrorMessage(String code){
    final localization = noContextLocalization();

    switch (code) {
      case 'error_invalid_email':
        return localization.errorInvalidEmail;
      case 'error_user_not_found':
        return localization.errorUserNotFound;
      default:
        return localization.resetPasswordEmailDefaultError;
    }
  }
}