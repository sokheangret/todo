import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high
}

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final Priority priority;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime? dueDate;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    required this.priority,
    this.isCompleted = false,
    this.dueDate,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    Priority? priority,
    bool? isCompleted,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Color get priorityColor {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  String toString() {
    return 'Todo(id: $id, title: $title, description: $description, category: $category, priority: $priority, isCompleted: $isCompleted, dueDate: $dueDate)';
  }
} 