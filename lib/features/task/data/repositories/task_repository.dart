import 'package:task_management_app/core/database/hive_service.dart';
import 'package:task_management_app/core/database/sqlite_service.dart';

import 'package:task_management_app/features/task/data/models/user_preferences_model.dart';
import '../models/task_model.dart';

class TaskRepository {
  final SQLiteService _sqliteService = SQLiteService();
  final HiveService _hiveService = HiveService();

  // Task-related methods using SQLite
  Future<void> addTask(TaskModel task) async {
    await _sqliteService.addTask(task);
  }

  Future<List<TaskModel>> getTasks() async {
    return await _sqliteService.getTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await _sqliteService.updateTask(task);
  }

  Future<void> deleteTask(int id) async {
    await _sqliteService.deleteTask(id);
  }

  Future<void> markAsCompletedAndPending(int id, bool status) async {
    await _sqliteService.updateTaskStatus(id,status);
  }

  // User preferences-related methods using Hive
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    await _hiveService.saveUserPreferences(preferences);
  }

  Future<UserPreferences?> getUserPreferences() async {
    return await _hiveService.getUserPreferences();
  }
}
