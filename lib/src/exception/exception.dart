class AExceptions implements Exception {

  /// The associated error message.

  final String message;

  /// (@macro log_in_with_email_ond_password_failure)

  const AExceptions([this.message ='An unknown exception occurred.']);

  /// Create an authentication message

  /// from a firebase authentication exception code.

  factory AExceptions.fromCode(String code) {
   switch (code) {

  case 'email-already-in-use':
    return const AExceptions('Email already exists.');

  case 'invalid-email':

  return const AExceptions('Email is not valid or badly formatted.');

  case 'weak-password':

  return const AExceptions ('Please enter a stronger password.');

  case 'user-disabled':

  return const AExceptions('This user has been disabled. Please contact support for help.');

  case 'user-not-found':

  return const AExceptions('Invalid Details, please create an account.');

  case 'wrong-password':

  return const AExceptions('Incorrect password, please try again.');

  case 'too-many-requests':

  return const AExceptions ('Too many requests, Service Temporarily blocked.');

  case 'invalid-argument':

  return const AExceptions('An invalid argument was provided to an Authentication method.');

  case 'invalid-password':

  return const AExceptions('Incorrect password, please try again.');

  case 'invalid-phone-number':
  return const AExceptions('The provided Phone Number is invalid.');
  case 'operation-not-allowed':
  return const AExceptions( 'The provided sign-in provider is disabled for your Firebase project.');

  case 'session-cookie-expired':

  return const AExceptions('The provided Firebase session cookie is expired.');

  case 'uid-already-exists':

  return const AExceptions('The provided uid is already in use by an existing user.'); default:

  return const AExceptions();
  }
  }
}