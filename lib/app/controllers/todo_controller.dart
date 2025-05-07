import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

enum TodoFilter { all, completed, pending }

class TodoController extends GetxController {
  late Box<Todo> _todoBox;
  final _todos = <Todo>[].obs;
  final _selectedCategory = 'All'.obs;
  final _selectedPriority = Rxn<Priority>();
  final _filter = TodoFilter.all.obs;

  List<Todo> get todos => _todos;
  List<Todo> get filteredTodos {
    switch (_filter.value) {
      case TodoFilter.completed:
        return _todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.pending:
        return _todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return _todos;
    }
  }

  List<String> get categories => ['All', ..._getUniqueCategories()];
  String get selectedCategory => _selectedCategory.value;
  Priority? get selectedPriority => _selectedPriority.value;

  @override
  void onInit() {
    super.onInit();
    _initHive();
  }

  Future<void> _initHive() async {
    _todoBox = await Hive.openBox<Todo>('todos');
    _loadTodos();
  }

  void _loadTodos() {
    _todos.value = _todoBox.values.toList();
  }

  void addTodo(Todo todo) {
    _todoBox.add(todo);
    _todos.add(todo);
  }

  void toggleTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      _todoBox.put(todo.id, updatedTodo);
      _todos[index] = updatedTodo;
    }
  }

  void deleteTodo(Todo todo) {
    _todoBox.delete(todo.id);
    _todos.removeWhere((t) => t.id == todo.id);
  }

  void setCategory(String category) {
    _selectedCategory.value = category;
  }

  void setPriority(Priority? priority) {
    _selectedPriority.value = priority;
  }

  void setFilter(TodoFilter filter) {
    _filter.value = filter;
  }

  List<String> _getUniqueCategories() {
    return _todos.map((todo) => todo.category).toSet().toList();
  }

  @override
  void onClose() {
    _todoBox.close();
    super.onClose();
  }
} 