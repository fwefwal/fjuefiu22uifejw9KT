import '../../domain/entities/task.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt,
  });

  factory TaskModel.fromEntity(Task task) => TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        isDone: task.isDone,
        createdAt: task.createdAt,
      );

  final String id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime createdAt;

  Task toEntity() => Task(
        id: id,
        title: title,
        description: description,
        isDone: isDone,
        createdAt: createdAt,
      );

  TaskModel copyWith({bool? isDone}) => TaskModel(
        id: id,
        title: title,
        description: description,
        isDone: isDone ?? this.isDone,
        createdAt: createdAt,
      );
}
