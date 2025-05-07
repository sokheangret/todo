import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/controllers/todo_controller.dart';
import 'package:todo/app/models/todo.dart';
import 'package:uuid/uuid.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add New Task',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      _dueDate == null
                          ? 'Set Due Date'
                          : 'Due: ${_formatDate(_dueDate!)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.flag),
                  const SizedBox(width: 8),
                  const Text('Priority:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SegmentedButton<Priority>(
                      segments: const [
                        ButtonSegment(
                          value: Priority.low,
                          label: Text('Low'),
                          icon: Icon(Icons.arrow_downward),
                        ),
                        ButtonSegment(
                          value: Priority.medium,
                          label: Text('Medium'),
                          icon: Icon(Icons.arrow_forward),
                        ),
                        ButtonSegment(
                          value: Priority.high,
                          label: Text('High'),
                          icon: Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: {_priority},
                      onSelectionChanged: (Set<Priority> selected) {
                        setState(() {
                          _priority = selected.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _submitForm,
                    child: const Text('Add Task'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final todo = Todo(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        category: 'General', // Default category
        priority: _priority,
        isCompleted: false,
        dueDate: _dueDate,
      );

      Get.find<TodoController>().addTodo(todo);
      Navigator.pop(context);
    }
  }
} 