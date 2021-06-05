part of 'verbose_bloc.dart';

@immutable
abstract class VerboseState {
  final String title;
  final String message;
  final double value;

  VerboseState(this.title, this.message, {this.value});
}

class VerboseInitial extends VerboseState {
  VerboseInitial({String title, String message, double value})
      : super(title, message, value: value);
}

class VerboserUpdate extends VerboseState {
  VerboserUpdate({String title, String message, double value})
      : super(title, message, value: value);
}

class VerboseOperationUpdate extends VerboseState {
  VerboseOperationUpdate({String title, String message, double value})
      : super(title, message, value: value);
}

class VerboseProgressComplete extends VerboseState  {
  VerboseProgressComplete({String title, String message, double value})
      : super(title, message, value: value);
}

class VerboseProgressFailed extends VerboseState  {
  VerboseProgressFailed({String title, String message, double value})
      : super(title, message, value: value);
}

class VerboseErrorState extends VerboseState {
  VerboseErrorState({String title, String message, double value})
      : super(title, message, value: value);
}

class VerboseSnackBarState extends VerboseState {
  VerboseSnackBarState({String title, String message})
      : super(title, message, value: 0);
}