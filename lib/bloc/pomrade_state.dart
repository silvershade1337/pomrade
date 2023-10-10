part of 'pomrade_bloc.dart';

sealed class PomradeState extends Equatable {
  const PomradeState();
  
  @override
  List<Object> get props => [];
}

final class PomradeInitial extends PomradeState {}
