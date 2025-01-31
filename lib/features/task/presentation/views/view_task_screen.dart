import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';



class ViewTaskScreen extends StatelessWidget {
  final TaskModel task;

  const ViewTaskScreen({Key? key, required this.task}) : super(key: key);

  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
        return 'Low';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
         titleTextStyle: TextStyle(color: Colors.white),
        title: Text('View Task'),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Title
              Text(
                task.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
              ),
              SizedBox(height: 12),

              // Task Priority
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: task.priority == 1
                      ? Colors.red.shade100
                      : task.priority == 2
                          ? Colors.orange.shade100
                          : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Priority: ${getPriorityText(task.priority)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
              ),
              SizedBox(height: 12),

              // Task Due Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Colors.deepOrangeAccent,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Due Date: ${task.date.toLocal()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Task Status
              Row(
                children: [
                  Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.pending_actions,
                    color: task.isCompleted ? Colors.green : Colors.red,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Status: ${task.isCompleted ? 'Completed' : 'Pending'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: task.isCompleted ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Description Title
              Text(
                'Description',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              SizedBox(height: 8),

              // Task Description
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
