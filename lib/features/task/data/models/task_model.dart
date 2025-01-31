import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskModel {
  final int id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime date; // Field to store task date
  final int priority;  // Field to store task priority (e.g., 1 = high, 2 = medium, 3 = low)

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
    required this.priority,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1, // Convert 1/0 to boolean
      date: DateTime.parse(map['date']), // Convert date from string
      priority: map['priority'], // Get priority
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0, // Convert boolean to 1/0
      'date': date.toIso8601String(), // Store date as ISO string
      'priority': priority, // Store priority
    };
  }
}
