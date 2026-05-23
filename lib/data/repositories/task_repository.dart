import '../../domain/entities/task.dart';
import '../../domain/repositories/i_task_repository.dart';
import '../models/task_model.dart';

/// In-memory implementation of [ITaskRepository].
/// In a real app this would use a local DB (Isar / Drift) or remote API.
class TaskRepository implements ITaskRepository {
  final List<TaskModel> _store = [];

  @override
  Future<List<Task>> getTasks() async {
    return _store.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    _store.add(TaskModel.fromEntity(task));
  }

  @override
  Future<void> toggleTask(String id) async {
    final index = _store.indexWhere((m) => m.id == id);
    if (index == -1) return;
    _store[index] = _store[index].copyWith(isDone: !_store[index].isDone);
  }

  @override
  Future<void> deleteTask(String id) async {
    _store.removeWhere((m) => m.id == id);
  }
}
