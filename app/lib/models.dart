import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class Utilities {
  static String formatDuration(Duration duration) {
    var hours = duration.inHours, minutes = duration.inMinutes % 60, seconds = duration.inSeconds%60;
    return "${hours>0?hours:''}${hours>0?':':''}$minutes:${seconds<10?'0':''}$seconds";
  }
  static bool onlyDigits(String input) {
    for (var i=0; i<input.length; i++) {
      if( !( (input.codeUnitAt(i)  ^ 0x30) <= 9) ) {
        return false;
      }
    }
    return true;
  }
}

class SettingsManager {
  static const JsonEncoder jsonEncoder = JsonEncoder.withIndent("  ");
  static const JsonDecoder jsonDecoder = JsonDecoder();
  static String defaulSettings = const JsonEncoder.withIndent("  ").convert(
    {
      "sites": ["testblock.pomrade.com"],
      "pomoWork": 25,
      "pomoBreak": 5
    }
  );
  static late File settingsFile;
  static Map<String, dynamic>? _cache;
  static Map<String, dynamic> get cache {
    return _cache??(_cache = getSettings());
  }
  static bool setSettings(Map<String, dynamic> settings) {
    try {
      settingsFile.writeAsString(jsonEncoder.convert(settings));
      _cache = settings;
      return true;
    }
    catch (exc) {
      return false;
    }
  }

  static Map<String, dynamic> getSettings() {
    return jsonDecoder.convert(settingsFile.readAsStringSync());
  }
}

class Task {
  int id;
  String name;
  String? description;
  String? notes;
  DateTime created;
  List<String> tags = [];
  bool completed = false;

  Task({
    required this.id,
    required this.name,
    required this.created,
    List<String>? tags,
    this.notes,
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
      "notes": notes,
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
      notes: json["notes"],
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
