import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/task/data/models/task_model.dart';

class SQLiteService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          isCompleted INTEGER,
          date TEXT,
          priority INTEGER
        )
      ''');
    });
  }

  Future<void> addTask(TaskModel task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getTasks({String orderBy = 'date DESC'}) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: orderBy, // Add sorting condition (by date or priority)
    );
    return maps.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTaskStatus(int taskId, bool isCompleted) async {
    final db = await database;
    await db.update(
      'tasks',
      {'isCompleted': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
