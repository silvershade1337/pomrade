part of 'pomrade_bloc.dart';

sealed class PomradeEvent extends Equatable {
  const PomradeEvent();

  @override
  List<Object> get props => [];
}

class InitializeEvent extends PomradeEvent {
  final bool isWindows;

  const InitializeEvent(this.isWindows);
}