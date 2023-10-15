part of 'pomrade_bloc.dart';

class PomradeState extends Equatable {
  bool windows = false;
  String? scriptsLocation;
  String? dataLocation;
  List<Task> tasks = [];
  List<Site> sites = [];
  Task? startedTask;
  bool blockSites = false;
  DateTime? pomoStart;
  DateTime? subStart;
  String? pomoStatus;
  bool pomoOn = false;
  bool pomoWork = true;
  Duration? pomoWorkDuration = Duration(seconds: 45);
  Duration? pomoBreakDuration = Duration(seconds: 15);

  PomradeState();
  
  @override
  List<Object> get props => [];
}
