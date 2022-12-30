class FBAuthErrorMsgs {

  static String getEmailAuthErrorMsg(String code) {
    switch (code) {
      case 'user-disabled':
        return 'This user has been disabled. contact support for help.';
      case 'user-not-found':
        return 'Email is not found.';
      case 'wrong-password':
        return 'Incorrect password, please try again.';
      case 'invalid-email':
        return 'Email is not valid.';
      default:
        return 'Login Error.. please try again';
    }
  }

  static String getGoogleAuthErrorMsg(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'Account exists with different credentials.';
      case 'invalid-credential':
        return 'The credential received is malformed or has expired.';
      case 'operation-not-allowed':
        return 'Operation is not allowed.  Please contact support.';
      case 'user-disabled':
        return 'This user has been disabled. Please contact support for help.';
      case 'user-not-found':
        return 'Email is not found, please create an account.';
      case 'wrong-password':
        return 'Incorrect password, please try again.';
      case 'invalid-verification-code':
        return 'The credential verification code received is invalid.';
      case 'invalid-verification-id':
        return 'The credential verification ID received is invalid.';
      default:
        return "Google Login Error.. please try again";
    }
  }
}