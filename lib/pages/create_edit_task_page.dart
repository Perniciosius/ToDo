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
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              primary: true,
            ),
            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: EdgeInsets.all(padding),
            //     child: Align(
            //       alignment: Alignment.topRight,
            //       child: IconButton(
            //         onPressed: widget.closeContainer,
            //         icon: Icon(Icons.close),
            //       ),
            //     ),
            //   ),
            // ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: TextField(
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
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Text(
                  'CATEGORY',
                  style: TextStyle(color: secondaryTextColor),
                ),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Card(
                  clipBehavior: Clip.antiAlias,
                  color: _category == Category.values[index]
                      ? Color.alphaBlend(
                          Theme.of(context).accentColor.withOpacity(0.4),
                          Theme.of(context).cardColor,
                        )
                      : Theme.of(context).cardColor,
                  margin: EdgeInsets.all(padding),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: InkWell(
                    onTap: () {
                      _category = Category.values[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            getCategoryImageName(Category.values[index]),
                            width: 50.0,
                            height: 50.0,
                          ),
                          Text(
                            getCategoryName(Category.values[index]),
                            style: TextStyle(fontSize: 25.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                childCount: Category.values.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // crossAxisSpacing: padding,
                mainAxisSpacing: padding,
              ),
            )
          ],
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
