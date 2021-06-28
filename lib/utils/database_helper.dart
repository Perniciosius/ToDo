import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/model/todo_item.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/constants.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database?> _open() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnCategory integer,
  $columnDone integer not null)
''');
      },
    );
  }

  Future<ToDoItem> insert(ToDoItem todo) async {
    var db = await _open();
    todo.id = await db!.insert(tableTodo, todo.toMap());
    await db.close();
    return todo;
  }

  Future<ToDoItem?> getTodo(int id) async {
    var db = await _open();
    List<Map<String, Object?>> maps = await db!.query(tableTodo,
        columns: [columnId, columnDone, columnTitle, columnCategory],
        where: '$columnId = ?',
        whereArgs: [id]);
    await db.close();
    if (maps.length > 0) {
      return ToDoItem.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ToDoItem>> getTodoList() async {
    var db = await _open();
    List<Map<String, Object?>> maps = await db!.query(
      tableTodo,
      columns: [columnId, columnDone, columnTitle, columnCategory],
    );
    await db.close();
    if (maps.length > 0) {
      return maps.map((todo) => ToDoItem.fromMap(todo)).toList();
    }
    return [];
  }

  Future<int> getPersonalTodoCount() async {
    var db = await _open();
    var maps = await db!.rawQuery(
        'SELECT COUNT(*) AS $columnCount FROM $tableTodo WHERE $columnCategory = ${Category.PERSONAL.index}');
    await db.close();
    if (maps.length > 0) {
      return maps.first[columnCount] as int;
    }
    return 0;
  }

  Future<int> getWorkTodoCount() async {
    var db = await _open();
    var maps = await db!.rawQuery(
        'SELECT COUNT(*) AS $columnCount FROM $tableTodo WHERE $columnCategory = ${Category.WORK.index}');
    await db.close();
    if (maps.length > 0) {
      return maps.first[columnCount] as int;
    }
    return 0;
  }

  Future<int> delete(int id) async {
    var db = await _open();
    int changes =
        await db!.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
    await db.close();
    return changes;
  }

  Future<int> update(ToDoItem todo) async {
    var db = await _open();
    int changes = await db!.update(tableTodo, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
    await db.close();
    return changes;
  }
}
