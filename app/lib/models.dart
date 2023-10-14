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

class Site {
  String domain;

  Site({
    required this.domain,
  });
  
  static String? getDomain(String url) {
    RegExp re = RegExp(r"((?:[A-z0-9]+\.)+[A-z0-9]+)");
    RegExpMatch? match = re.firstMatch(url);
    return match?.group(1);
  }
}
