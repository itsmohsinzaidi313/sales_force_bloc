part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged({this.email});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged({this.password});
}

class LoginSubmit extends LoginEvent {
  final bool forceLogin;
  LoginSubmit({this.forceLogin = false});
}

class LoginGetLastLogin extends LoginEvent {}

class LoginEventLogout extends LoginEvent {}
