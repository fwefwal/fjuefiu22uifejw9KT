import '../entities/task.dart';
import '../repositories/i_task_repository.dart';

class AddTaskUseCase {
  const AddTaskUseCase(this._repository);

  final ITaskRepository _repository;

  Future<void> call(Task task) => _repository.addTask(task);
}
