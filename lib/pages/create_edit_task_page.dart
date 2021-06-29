import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/model/todo_item.dart';
import 'package:to_do/provider/todo_provider.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/constants.dart';

class CreateEditTaskPage extends StatefulWidget {
  final ToDoItem? toDoItem;
  final Function() closeContainer;
  const CreateEditTaskPage({
    Key? key,
    this.toDoItem,
    required this.closeContainer,
  }) : super(key: key);

  @override
  _CreateEditTaskPageState createState() => _CreateEditTaskPageState();
}

class _CreateEditTaskPageState extends State<CreateEditTaskPage> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  late Category _category;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.toDoItem?.title);
    _focusNode = FocusNode();
    _category = widget.toDoItem?.category ?? Category.PERSONAL;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.closeContainer();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: 2.5 * padding,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: widget.closeContainer,
                  icon: Icon(Icons.close),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      cursorColor: secondaryTextColor,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: 'Create new task',
                        hintStyle: TextStyle(
                          color: secondaryTextColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2 * padding,
                        bottom: padding,
                      ),
                      child: Text(
                        'CATEGORY',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: secondaryTextColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: RadioListTile<Category>(
                            selected: _category == Category.PERSONAL,
                            activeColor: personalToDoColor,
                            selectedTileColor:
                                personalToDoColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            title: Text('Personal'),
                            value: Category.PERSONAL,
                            groupValue: _category,
                            onChanged: categoryOnChanged,
                          ),
                        ),
                        Container(
                          width: 130.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: secondaryTextColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: RadioListTile<Category>(
                            selected: _category == Category.WORK,
                            activeColor: workTodoColor,
                            selectedTileColor: workTodoColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            title: Text('Work'),
                            value: Category.WORK,
                            groupValue: _category,
                            onChanged: categoryOnChanged,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 2 * padding),
          child: FloatingActionButton.extended(
            icon: Icon(Icons.check),
            label: Text(
              widget.toDoItem == null ? 'Add task' : 'Update task',
            ),
            onPressed: () {
              var text = _textEditingController.text;
              if (text.length == 0) {
                _focusNode.requestFocus();
                return;
              }

              if (widget.toDoItem == null) {
                Provider.of<TodoProvider>(context, listen: false).create(
                  ToDoItem(
                    title: text,
                    category: _category,
                  ),
                );
              } else {
                Provider.of<TodoProvider>(context, listen: false).update(
                  ToDoItem(
                    id: widget.toDoItem!.id,
                    title: text,
                    category: _category,
                  ),
                );
              }
              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void categoryOnChanged(Category? value) {
    _category = value!;
    setState(() {});
  }
}
