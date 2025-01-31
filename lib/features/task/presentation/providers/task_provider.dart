import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:task_management_app/features/task/data/repositories/task_repository.dart';

import '../../data/models/task_model.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskRepository get _repository => TaskRepository();

 TaskNotifier() : super([]) {
    _loadInitialTasks(); // Load tasks when the notifier is created
  }

  Future<void> _loadInitialTasks() async {
    state = await _repository.getTasks(); // Load tasks from repository
  }

  Future<void> loadTasks() async {
    state = await _repository.getTasks();
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    await loadTasks(); // Reload tasks
  }

  Future<void> updateTask(TaskModel task) async {
    await _repository.updateTask(task);
    await loadTasks(); // Reload tasks
  }

  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    await loadTasks(); // Reload tasks
  }

  Future<void> markAsCompletedAndPending(int taskId, bool status) async {
    await _repository.markAsCompletedAndPending(taskId, status);
    await loadTasks();
  }
}
