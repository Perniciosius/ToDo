import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/pages/create_edit_task_page.dart';
import 'package:to_do/provider/theme_provider.dart';
import 'package:to_do/provider/todo_provider.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/widgets/category_card.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/widgets/task_list.dart';
import 'package:animations/animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: true,
            actions: [
              IconButton(
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      pageBuilder: (context, animation, _) => BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10.0,
                              sigmaY: 10.0,
                            ),
                            child: Center(
                              child: ThemeDialog(),
                            ),
                          ));
                },
                icon: Icon(
                  Theme.of(context).scaffoldBackgroundColor ==
                          lightBackgroundColor
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                ),
                color: secondaryTextColor,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'What\'s Up',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Theme.of(context).textTheme.headline1?.color,
                  fontWeight: Theme.of(context).textTheme.headline1?.fontWeight,
                ),
              ),
              titlePadding: EdgeInsetsDirectional.only(
                start: padding,
                bottom: padding / 2,
              ),
            ),
            expandedHeight: 100.0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(
                    top: 2 * padding,
                    left: padding,
                    right: padding,
                  ),
                  child: Text(
                    "CATEGORIES",
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Category.values.length,
                    itemBuilder: (context, index) {
                      var category = Category.values[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        color: _selectedCategory == category
                            ? Color.alphaBlend(
                                Theme.of(context).accentColor.withOpacity(0.25),
                                Theme.of(context).cardColor,
                              )
                            : Theme.of(context).cardColor,
                        margin: EdgeInsets.all(margin),
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: InkWell(
                          onTap: () {
                            _selectedCategory =
                                _selectedCategory != category ? category : null;
                            setState(() {});
                            Provider.of<TodoProvider>(context, listen: false)
                                .applyCategoryFilter(_selectedCategory);
                          },
                          child: CategoryCard(category: category),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: padding,
                    top: 2 * padding,
                  ),
                  child: Text(
                    'TODAY\'S TASKS',
                    style: TextStyle(color: secondaryTextColor),
                  ),
                ),
              ],
            ),
          ),
          TaskList(),
        ],
      ),
      floatingActionButton: OpenContainer(
        openColor: Theme.of(context).scaffoldBackgroundColor,
        closedColor: Theme.of(context).scaffoldBackgroundColor,
        openBuilder: (_, closeContainer) => CreateEditTaskPage(
          closeContainer: closeContainer,
        ),
        closedBuilder: (_, openContainer) => FloatingActionButton.extended(
          label: Text('New'),
          icon: Icon(Icons.create),
          onPressed: openContainer,
        ),
        openShape: _shapeBorder,
        closedShape: _shapeBorder,
        tappable: false,
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  final ShapeBorder _shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50),
  );
}

class ThemeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _themeMode = Provider.of<ThemeProvider>(context).themeMode;
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        height: dialogSize,
        width: dialogSize,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Text(
                'THEME',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 20.0,
                ),
              ),
            ),
            RadioListTile<ThemeMode>(
              title: Text('System'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: onThemeChange(context, _themeMode),
            ),
            RadioListTile<ThemeMode>(
              title: Text('Light'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: onThemeChange(context, _themeMode),
            ),
            RadioListTile<ThemeMode>(
              title: Text('Dark'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: onThemeChange(context, _themeMode),
            ),
          ],
        ),
      ),
    );
  }

  Function(ThemeMode?) onThemeChange(
      BuildContext context, ThemeMode themeMode) {
    return (ThemeMode? value) {
      themeMode = value!;
      Provider.of<ThemeProvider>(context, listen: false).setThemeMode(value);
      Navigator.of(context).pop();
    };
  }
}
