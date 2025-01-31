import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/features/task/data/models/task_model.dart';
import 'package:task_management_app/features/task/presentation/providers/task_provider.dart';




class AddTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;

  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
 final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPriority = 'Medium'; // Default priority

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.date;
      _selectedPriority = widget.task!.priority == 1
          ? 'Low'
          : widget.task!.priority == 2
              ? 'Medium'
              : 'High';
    }
  }

  void _saveTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    // Convert the priority to an integer value
    int priority = _selectedPriority == 'Low'
        ? 1
        : _selectedPriority == 'Medium'
            ? 2
            : 3;

    if (widget.task != null) {
      // Update task
      ref.read(taskProvider.notifier).updateTask(
            TaskModel(
              id: widget.task!.id, // Keep the existing ID for updating
              title: title,
              description: description,
              isCompleted: true,
              date: _selectedDate,
              priority: priority,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task updated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Add new task
      ref.read(taskProvider.notifier).addTask(
            TaskModel(
              title: title,
              description: description,
              id: 0,
              isCompleted: false,
              date: _selectedDate,
              priority: priority,
            ),
          );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }

    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Update Task'),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth > 600; // Define tablet as devices with width > 600px

            return SingleChildScrollView(
              child: isTablet
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Task Form Section
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.task == null ? 'Add Task' : 'Update Task',
                                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrangeAccent,
                                    ),
                              ),
                              SizedBox(height: 20),
                              _buildTextField(
                                controller: _titleController,
                                label: 'Title',
                                icon: Icons.title,
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                icon: Icons.description,
                                maxLines: 4,
                              ),
                               SizedBox(height: 16),
                        _buildDatePicker(),
                        SizedBox(height: 16),
                        _buildPriorityDropdown(),
                        SizedBox(height: 20),
                     
                              ElevatedButton(
                                onPressed: _saveTask,
                                style: ElevatedButton.styleFrom(

                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                                  backgroundColor: Colors.deepOrangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  widget.task == null ? 'Add Task' : 'Update Task',
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildTextField(
                          controller: _titleController,
                          label: 'Title',
                          icon: Icons.title,
                        ),
                        SizedBox(height: 16),
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 4,
                        ),
                                        SizedBox(height: 16),
                        _buildDatePicker(),
                        SizedBox(height: 16),
                        _buildPriorityDropdown(),
                        SizedBox(height: 20),
           
                        ElevatedButton(
                          onPressed: _saveTask,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                            backgroundColor: Colors.deepOrangeAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.task == null ? 'Add Task' : 'Update Task',
                            style: TextStyle(fontSize: 16,color: Colors.white),
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepOrangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }

   Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: DateFormat.yMd().format(_selectedDate),
          ),
          decoration: InputDecoration(
            labelText: 'Due Date',
            prefixIcon: Icon(Icons.date_range, color: Colors.deepOrangeAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.deepOrangeAccent),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPriority,
      onChanged: (value) {
        setState(() {
          _selectedPriority = value!;
        });
      },
      items: ['Low', 'Medium', 'High']
          .map(
            (priority) => DropdownMenuItem(
              value: priority,
              child: Text(priority),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: 'Priority',
        prefixIcon: Icon(Icons.priority_high, color: Colors.deepOrangeAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }

}
