class Task {
  int id;
  String name;
  String? description;
  DateTime created;
  List<String> tags = [];
  bool completed = false;

  Task({
    required this.id,
    required this.name,
    required this.created,
    List<String>? tags,
    this.completed = false,
    this.description
  }) {
    this.tags = tags??[];
  }
  
}
