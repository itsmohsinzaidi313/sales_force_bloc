part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginSuccessful extends LoginState {
  final String message;
  LoginSuccessful({this.message});
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({this.message});
}

class LoginError extends LoginState {
  final String message;
  LoginError({this.message});
}

class InvalidEmail extends LoginState {
  final String message;
  InvalidEmail({this.message});
}

class InvalidPassword extends LoginState {
  final String message;
  InvalidPassword({this.message});
}

class InvalidSubmission extends LoginState {
  final String message;
  InvalidSubmission({this.message});
}

class SavedUser extends LoginState {
  final String email;
  SavedUser({this.email});
}

class NewUser extends LoginState {}
