import '../entities/task.dart';

abstract interface class ITaskRepository {
  Future<List<Task>> getTasks();
  Future<void> addTask(Task task);
  Future<void> toggleTask(String id);
  Future<void> deleteTask(String id);
}
