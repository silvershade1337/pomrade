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

class CompleteTaskEvent extends PomradeEvent {
  final int taskId;

  const CompleteTaskEvent(this.taskId);
}

class ToggleSiteblockEvent extends PomradeEvent {
  
}

class TasksChangedEvent extends PomradeEvent {
  final List<Task> tasks;

  const TasksChangedEvent(this.tasks);
}