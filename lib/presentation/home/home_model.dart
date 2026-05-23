import 'package:elementary/elementary.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/toggle_task_usecase.dart';

/// [ElementaryModel] — responsible only for business-logic calls.
/// It has NO reference to BuildContext, widgets or state.
class HomeModel extends ElementaryModel {
  HomeModel(
    this._getTasksUseCase,
    this._addTaskUseCase,
    this._toggleTaskUseCase,
    this._deleteTaskUseCase,
  );

  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final ToggleTaskUseCase _toggleTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  Future<List<Task>> loadTasks() => _getTasksUseCase();

  Future<void> addTask(Task task) => _addTaskUseCase(task);

  Future<void> toggleTask(String id) => _toggleTaskUseCase(id);

  Future<void> deleteTask(String id) => _deleteTaskUseCase(id);
}
