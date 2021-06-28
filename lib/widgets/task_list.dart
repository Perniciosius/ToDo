import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:to_do/model/todo_item.dart';
import 'package:to_do/pages/create_edit_task_page.dart';
import 'package:to_do/provider/todo_provider.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/utils/helper.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, _) {
        if (todoProvider.todoList == null) {
          return SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        var todoList = todoProvider.todoList!;

        if (todoList.length == 0) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                "Tasks finished.",
                style: TextStyle(color: secondaryTextColor),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.fromLTRB(
              padding, padding, padding, kFloatingActionButtonMargin + 54.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Dismissible(
                key: ValueKey(todoList[index].id),
                onDismissed: (direction) {
                  todoProvider.delete(todoList[index].id!);
                },
                background: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    Text(
                      'Delete task',
                      style: TextStyle(color: secondaryTextColor),
                    )
                  ],
                ),
                secondaryBackground: Row(
                  children: [
                    Spacer(),
                    Text(
                      'Delete task',
                      style: TextStyle(color: secondaryTextColor),
                    ),
                    Icon(Icons.delete_outlined),
                  ],
                ),
                child: ListItem(
                  toDoItem: todoList[index],
                ),
              ),
              childCount: todoList.length,
            ),
          ),
        );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final ToDoItem toDoItem;
  ListItem({Key? key, required this.toDoItem}) : super(key: key);

  final ShapeBorder _shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: OpenContainer(
        clipBehavior: Clip.antiAlias,
        openElevation: 10.0,
        closedElevation: 10.0,
        openShape: _shapeBorder,
        closedShape: _shapeBorder,
        openColor: Theme.of(context).scaffoldBackgroundColor,
        closedColor: Theme.of(context).cardColor,
        tappable: false,
        transitionDuration: Duration(milliseconds: 500),
        closedBuilder: (_, openContainer) => ListTile(
          leading: Checkbox(
            activeColor: getCategoryColor(toDoItem.category)
                .withOpacity(toDoItem.done ? 0.4 : 1.0),
            side: BorderSide(
              color: getCategoryColor(toDoItem.category),
              width: thickness,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            value: toDoItem.done,
            onChanged: (value) {
              toDoItem.done = value!;
              Provider.of<TodoProvider>(context, listen: false)
                  .update(toDoItem);
            },
          ),
          title: Text(
            toDoItem.title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              decoration: toDoItem.done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              decorationThickness: thickness,
            ),
          ),
          onTap: openContainer,
        ),
        openBuilder: (_, closeContainer) => CreateEditTaskPage(
          closeContainer: closeContainer,
          toDoItem: toDoItem,
        ),
      ),
    );
  }
}
