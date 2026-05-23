import '../repositories/i_task_repository.dart';

class ToggleTaskUseCase {
  const ToggleTaskUseCase(this._repository);

  final ITaskRepository _repository;

  Future<void> call(String id) => _repository.toggleTask(id);
}
