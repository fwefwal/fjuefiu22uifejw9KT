import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/repositories/task_repository.dart';
import '../domain/repositories/i_task_repository.dart';
import '../domain/usecases/add_task_usecase.dart';
import '../domain/usecases/delete_task_usecase.dart';
import '../domain/usecases/get_tasks_usecase.dart';
import '../domain/usecases/toggle_task_usecase.dart';

/// Root DI container. Wraps the widget tree with all needed providers.
class AppDependencies extends StatelessWidget {
  const AppDependencies({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Data layer
        Provider<ITaskRepository>(
          create: (_) => TaskRepository(),
        ),

        // Use-cases (domain layer)
        ProxyProvider<ITaskRepository, GetTasksUseCase>(
          update: (_, repo, __) => GetTasksUseCase(repo),
        ),
        ProxyProvider<ITaskRepository, AddTaskUseCase>(
          update: (_, repo, __) => AddTaskUseCase(repo),
        ),
        ProxyProvider<ITaskRepository, ToggleTaskUseCase>(
          update: (_, repo, __) => ToggleTaskUseCase(repo),
        ),
        ProxyProvider<ITaskRepository, DeleteTaskUseCase>(
          update: (_, repo, __) => DeleteTaskUseCase(repo),
        ),
      ],
      child: child,
    );
  }
}
