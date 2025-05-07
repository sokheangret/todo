import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/todo.dart';
import '../controllers/todo_controller.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/todo_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context, controller),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatsCard(context, controller),
          Expanded(
            child: Obx(() {
              if (controller.filteredTodos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to add a new task',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = controller.filteredTodos[index];
                  return TodoItem(
                    todo: todo,
                    onToggle: () => controller.toggleTodo(todo),
                    onDelete: () => controller.deleteTodo(todo),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTodoDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, TodoController controller) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              'Total',
              controller.todos.length.toString(),
              Icons.list_alt,
            ),
            _buildStatItem(
              context,
              'Completed',
              controller.todos.where((todo) => todo.isCompleted).length.toString(),
              Icons.check_circle_outline,
            ),
            _buildStatItem(
              context,
              'Pending',
              controller.todos.where((todo) => !todo.isCompleted).length.toString(),
              Icons.pending_actions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showFilterDialog(BuildContext context, TodoController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Tasks'),
              leading: const Icon(Icons.list),
              onTap: () {
                controller.setFilter(TodoFilter.all);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Completed'),
              leading: const Icon(Icons.check_circle_outline),
              onTap: () {
                controller.setFilter(TodoFilter.completed);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pending'),
              leading: const Icon(Icons.pending_actions),
              onTap: () {
                controller.setFilter(TodoFilter.pending);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );
  }
} 