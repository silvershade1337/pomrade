part of 'pomrade_bloc.dart';

class PomradeState extends Equatable {
  bool windows = false;
  String? scriptsLocation;
  String? dataLocation;
  List<Task> tasks = [];
  List<Site> sites = [];
  bool blockSites = false;

  PomradeState();
  
  @override
  List<Object> get props => [];
}
