import '../entities/task.dart';
import '../repositories/i_task_repository.dart';

class GetTasksUseCase {
  const GetTasksUseCase(this._repository);

  final ITaskRepository _repository;

  Future<List<Task>> call() => _repository.getTasks();
}
