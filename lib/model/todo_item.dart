import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/constants.dart';

class ToDoItem {
  int? id;
  late String title;
  late Category category;
  bool done = false;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0,
      columnCategory: category.index,
    };
    map[columnId] = id;
    return map;
  }

  ToDoItem({
    this.id,
    required this.title,
    required this.category,
  }) : done = false;

  ToDoItem.fromMap(Map<String, Object?> map) {
    id = map[columnId] as int;
    title = map[columnTitle] as String;
    done = map[columnDone] == 1;
    category = Category.values[map[columnCategory] as int];
  }
}
