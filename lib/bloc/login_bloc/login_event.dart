part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginSubmit extends LoginEvent {
  final bool forceLogin;
  final User user;
  LoginSubmit({this.user, this.forceLogin = false});
}

class LoginGetLastLogin extends LoginEvent {}

class LoginEventLogout extends LoginEvent {}
