import 'package:flutter/material.dart';
import 'package:to_do/model/todo_item.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/database_helper.dart';

class TodoProvider with ChangeNotifier {
  List<ToDoItem>? _toDoList;

  Category? _categoryFilter;

  List<ToDoItem>? get todoList => _categoryFilter == null
      ? _toDoList
      : _toDoList
          ?.where((element) => element.category == _categoryFilter)
          .toList();

  int categoryTaskCount(Category category) => (_toDoList != null)
      ? _toDoList!
          .where((element) => element.category == category)
          .toList()
          .length
      : 0;

  int categoryCompletedTaskCount(Category category) => (_toDoList != null)
      ? _toDoList!
          .where((element) => element.category == category && element.done)
          .toList()
          .length
      : 0;

  DatabaseHelper _databaseHelper = DatabaseHelper();

  TodoProvider() {
    fetchDatabase();
  }

  void fetchDatabase() async {
    _toDoList = await _databaseHelper.getTodoList();
    // _personalCount = await _databaseHelper.getPersonalTodoCount();
    // _workCount = await _databaseHelper.getWorkTodoCount();
    notifyListeners();
  }

  ToDoItem getTodo(int id) {
    return _toDoList!.firstWhere((element) => element.id == id);
  }

  void create(ToDoItem todoItem) async {
    todoItem = await _databaseHelper.insert(todoItem);
    fetchDatabase();
    // _personalCount = await _databaseHelper.getPersonalTodoCount();
    // _workCount = await _databaseHelper.getWorkTodoCount();
    // _toDoList!.add(todoItem);
    // notifyListeners();
  }

  void delete(int id) async {
    await _databaseHelper.delete(id);
    fetchDatabase();
    // _personalCount = await _databaseHelper.getPersonalTodoCount();
    // _workCount = await _databaseHelper.getWorkTodoCount();
    // _toDoList!.removeWhere((element) => element.id == id);
    // notifyListeners();
  }

  void update(ToDoItem todoItem) async {
    await _databaseHelper.update(todoItem);
    fetchDatabase();
    // _personalCount = await _databaseHelper.getPersonalTodoCount();
    // _workCount = await _databaseHelper.getWorkTodoCount();
    // var index = _toDoList!.indexWhere((element) => element.id == todoItem.id);
    // _toDoList![index] = todoItem;
    // notifyListeners();
  }

  void applyCategoryFilter(Category? category) {
    _categoryFilter = category;
    notifyListeners();
  }
}
