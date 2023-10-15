import 'dart:convert';

import 'package:flutter/foundation.dart';

class Utilities {
  static String formatDuration(Duration duration) {
    var hours = duration.inHours, minutes = duration.inMinutes % 60, seconds = duration.inSeconds%60;
    return "${hours>0?hours:''}${hours>0?':':''}$minutes:${seconds<10?'0':''}$seconds";
  }
}

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

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "created": created.toIso8601String(),
      "tags": tags,
      "completed": completed
    };
  }

  factory Task.fromMap(Map<dynamic, dynamic> json) {
    return Task(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      created: DateTime.parse(json["created"]),
      tags: (json["tags"] as List<dynamic>).map((e) => e.toString()).toList(),
      completed: json["completed"]
    );
  }
}

extension TaskList on List<Task> {
  static const encoder = JsonEncoder.withIndent("  ");
  static List<Task> fromJson(String json) {
    List jsonDecoded = jsonDecode(json);
    print(jsonDecoded);
    return jsonDecoded.map((e) => Task.fromMap(e)).toList();
  }

  String toJson() {
    return encoder.convert(map((e) => e.toMap()).toList());
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
