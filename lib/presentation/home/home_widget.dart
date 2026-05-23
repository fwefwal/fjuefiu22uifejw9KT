import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';
import 'home_widget_model.dart';

/// [ElementaryWidget] — pure View. Reads state from [HomeWidgetModel]
/// and delegates all interactions back to the WidgetModel.
class HomeWidget extends ElementaryWidget<HomeWidgetModel> {
  const HomeWidget({super.key})
      : super(defaultHomeWidgetModelFactory);

  @override
  Widget build(HomeWidgetModel wm) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        foregroundColor: Colors.white,
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => wm.showAddTaskSheet(),
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
      body: EntityStateNotifierBuilder<List<Task>>(
        listenableEntityState: wm.tasksState,
        loadingBuilder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, __, ___) =>
            const Center(child: Text('Something went wrong')),
        builder: (_, tasks) {
          final list = tasks ?? [];
          if (list.isEmpty) {
            return const _EmptyState();
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, index) {
              final task = list[index];
              return _TaskCard(
                task: task,
                onToggle: () => wm.toggleTask(task.id),
                onDelete: () => wm.deleteTask(task.id),
              );
            },
          );
        },
      ),
    );
  }

}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: task.isDone
            ? const Color(0xFFEEF0F8)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: task.isDone
                  ? const Color(0xFF6C63FF)
                  : Colors.transparent,
              border: Border.all(
                color: task.isDone
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFFCBD0E0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: task.isDone
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 18)
                : null,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: task.isDone
                ? const Color(0xFFA0A8C0)
                : const Color(0xFF1A1F2E),
            decoration:
                task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description.isNotEmpty
            ? Text(
                task.description,
                style: TextStyle(
                  fontSize: 13,
                  color: task.isDone
                      ? const Color(0xFFBEC4D6)
                      : const Color(0xFF6B7394),
                ),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded,
              color: Color(0xFFE0738A)),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.task_alt_rounded,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9099B7),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap + to add your first task',
            style: TextStyle(color: Color(0xFFB0BAD4)),
          ),
        ],
      ),
    );
  }
}
