part of 'verbose_bloc.dart';

@immutable
abstract class VerboseState {
  final String title;
  final String message;

  VerboseState(this.title, this.message);
}

class VerboseInitial extends VerboseState {
  VerboseInitial({String title, String message}) : super(title, message);
}

class VerboserUpdate extends VerboseState {
  VerboserUpdate({String title, String message}) : super(title, message);
}

class VerboseOperationUpdate extends VerboseState {
  VerboseOperationUpdate({String title, String message})
      : super(title, message);
}

class VerboseErrorState extends VerboseState {
  VerboseErrorState({String title, String message}) : super(title, message);
}
