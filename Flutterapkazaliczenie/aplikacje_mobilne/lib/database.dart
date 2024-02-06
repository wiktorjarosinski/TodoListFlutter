import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class Task {
  String name;
  String description;
  bool isCompleted;
  DateTime creationDate;

  Task({
    required this.name,
    required this.description,
    this.isCompleted = false,
    required DateTime creationDate,
  }) : creationDate = creationDate;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      creationDate: DateTime.parse(json['creationDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isCompleted': isCompleted,
      'creationDate': creationDate.toIso8601String(),
    };
  }

  static List<Map<String, dynamic>> toJsonList(List<Task> tasks) {
    return tasks.map((task) => task.toJson()).toList();
  }

  static List<Task> fromJsonList(String jsonString) {
    List<Map<String, dynamic>> jsonList =
        List<Map<String, dynamic>>.from(json.decode(jsonString) as Iterable);
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }
}

class DatabaseHandler {
  Database? _database;

  DatabaseHandler._();

  static final DatabaseHandler instance = DatabaseHandler._();

  factory DatabaseHandler() => instance;

  Future<void> open() async {
    try {
      if (!(_database?.isOpen ?? false)) {
        String path = '${await getDatabasesPath()}/database.db';
        _database = await openDatabase(
          path,
          version: 1,
          onCreate: (db, version) {
            db.execute('CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, name TEXT, description TEXT, isCompleted INTEGER, creationDate TEXT)');
          },
        );
      }
    } catch (e) {
      print('Error opening the database: $e');
    }
  }

  Future<List<Task>> allTasks() async {
    await open();
    if (_database == null || !(_database?.isOpen ?? false)) {
      return [];
    }

    List<Map<String, dynamic>> data = await _database!.query('tasks');
    return data.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> addTask(Task task) async {
    await open();
    if (_database == null || !(_database?.isOpen ?? false)) {
      return;
    }
    await _database!.insert('tasks', task.toJson());
  }

  Future<void> deleteTask() async {
    await open();
    if (_database == null || !(_database?.isOpen ?? false)) {
      return;
    }
    await _database!.delete('tasks');
  }

  Future<void> addTasksToList(List<Map<String, dynamic>> taskMaps) async {
    await open();
    if (_database == null || !(_database?.isOpen ?? false)) {
      return;
    }
    for (var taskMap in taskMaps) {
      await _database!.insert('tasks', taskMap);
    }
  }

  void close() {
    if (_database != null && _database!.isOpen) {
      _database!.close();
    }
  }
}
