

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/features/task/data/models/task_model.dart';
import 'package:task_management_app/features/task/presentation/providers/task_provider.dart';
import 'package:task_management_app/features/task/presentation/providers/user_preferences_provider.dart';

import 'package:task_management_app/features/task/presentation/views/add_update_task_screen.dart';
import 'package:task_management_app/features/task/presentation/views/view_task_screen.dart';

import 'package:flutter/animation.dart';

class TaskScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);
    final userPreferences = ref.watch(userPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent,
        title: Text("Tasks"),
        actions: [
          IconButton(
            icon: Icon(
              userPreferences?.theme == 'dark'
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(userPreferencesProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileView(context, tasks, ref);
          } else {
            return _buildTabletView(tasks, ref);
          }
        },
      ),
    );
  }

  Widget _buildMobileView(BuildContext context, List<TaskModel> tasks, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            backgroundColor: Colors.deepOrangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddTaskScreen()),
            );
          },
          child: Text("Add NEW Task", style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 20),
        Expanded(
          child: tasks.isEmpty
              ? Center(child: Text("No tasks available"))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _buildTaskItem(context, task, ref);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTabletView(List<TaskModel> tasks, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return _buildTaskItem(context, task, ref);
            },
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: Center(
            child: Text('Task Details will appear here'), // Placeholder
          ),
        ),
      ],
    );
  }

  // Animation for task items
  Widget _buildTaskItem(BuildContext context, TaskModel task, WidgetRef ref) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 300),
      child: ScaleTransition(
        scale: AlwaysStoppedAnimation(1.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: EdgeInsets.all(8),
            title: Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                task.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                    color: task.isCompleted ? Colors.green : null,
                  ),
                  onPressed: () {
                    _showConfirmationDialog(context, task.id!, task.isCompleted, ref);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ViewTaskScreen(task: task)),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.orangeAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddTaskScreen(task: task)),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, task.id, ref);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, int taskId, bool isCompleted, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedDialog(
          child: AlertDialog(
            title: Text(isCompleted ? 'Mark as Pending?' : 'Mark as Completed?'),
            content: Text(
              isCompleted
                  ? 'Do you want to mark this task as pending?'
                  : 'Do you want to mark this task as completed?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  ref
                      .read(taskProvider.notifier)
                      .markAsCompletedAndPending(taskId, !isCompleted);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isCompleted
                          ? 'Task marked as Pending'
                          : 'Task marked as Completed'),
                      backgroundColor: isCompleted ? Colors.orange : Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text(
                  isCompleted ? 'Mark as Pending' : 'Mark as Completed',
                  style: TextStyle(color: isCompleted ? Colors.orange : Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int taskId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedDialog(
          child: AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  ref.read(taskProvider.notifier).deleteTask(taskId);
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task deleted successfully!'),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }
}


class AnimatedDialog extends StatelessWidget {
  final Widget child;

  AnimatedDialog({required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: child,
    );
  }
}
