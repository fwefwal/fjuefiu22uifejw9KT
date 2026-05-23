import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/toggle_task_usecase.dart';
import 'home_model.dart';
import 'home_widget.dart';

/// Factory used by [HomeWidget] to obtain its [WidgetModel].
HomeWidgetModel defaultHomeWidgetModelFactory(BuildContext context) {
  return HomeWidgetModel(
    HomeModel(
      context.read<GetTasksUseCase>(),
      context.read<AddTaskUseCase>(),
      context.read<ToggleTaskUseCase>(),
      context.read<DeleteTaskUseCase>(),
    ),
  );
}

/// [WidgetModel] — the ViewModel. Holds UI state and exposes
/// [StateNotifier]s / [EntityStateNotifier]s that the Widget listens to.
class HomeWidgetModel extends WidgetModel<HomeWidget, HomeModel> {
  HomeWidgetModel(super.model);

  static const _uuid = Uuid();

  /// Tasks list state: loading / data / error
  final _tasksState = EntityStateNotifier<List<Task>>();

  EntityStateNotifier<List<Task>> get tasksState => _tasksState;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasksState.loading();
    try {
      final tasks = await model.loadTasks();
      _tasksState.content(tasks);
    } on Exception catch (e) {
      _tasksState.error(e);
    }
  }

  Future<void> addTask({required String title, required String description}) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      isDone: false,
      createdAt: DateTime.now(),
    );
    await model.addTask(task);
    await _loadTasks();
  }

  Future<void> toggleTask(String id) async {
    await model.toggleTask(id);
    await _loadTasks();
  }

  Future<void> deleteTask(String id) async {
    await model.deleteTask(id);
    await _loadTasks();
  }

  void showAddTaskSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'New Task',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: titleCtrl,
              decoration: _inputDeco('Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descCtrl,
              decoration: _inputDeco('Description (optional)'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final title = titleCtrl.text.trim();
                if (title.isEmpty) return;
                addTask(
                  title: title,
                  description: descCtrl.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Add',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
}
