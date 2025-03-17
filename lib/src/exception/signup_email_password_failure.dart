
class SignUpEmailPasswordFailure{
  final String message;
  const SignUpEmailPasswordFailure([this.message="An Unknown Error Occured."]);
  factory SignUpEmailPasswordFailure.code(String code){
    switch(code){
      case 'weak password':
        return const SignUpEmailPasswordFailure('Please enter a stronger Password');
      case 'Invalidemail':
        return const SignUpEmailPasswordFailure('Email is not valid or badly formatted');
      case 'email already in use':
        return const SignUpEmailPasswordFailure('An account already exists for that email');
      case 'operation not allowed':
        return const SignUpEmailPasswordFailure('operation not allowed.Please contact support');
      case 'User-disabled':
        return const SignUpEmailPasswordFailure('This user has been disabled. Please contact support for help');
      default:
        return const SignUpEmailPasswordFailure();
    }
  }
}