import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:to_do/provider/todo_provider.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/constants.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      child: Padding(
          padding: EdgeInsets.all(padding),
          child: Consumer<TodoProvider>(
            builder: (context, todoProvider, _) {
              var taskCount = todoProvider.categoryTaskCount(category);
              var completedTaskCount =
                  todoProvider.categoryCompletedTaskCount(category);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        getCategoryImageName(category),
                        width: 50.0,
                        height: 50.0,
                      ),
                      Text(
                        '$taskCount task' + (taskCount != 1 ? 's' : ''),
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ],
                  ),
                  Text(
                    getCategoryName(category),
                    style: TextStyle(fontSize: categoryFontSize),
                  ),
                  LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    percent:
                        taskCount != 0 ? completedTaskCount / taskCount : 1.0,
                    progressColor: getCategoryColor(category),
                    backgroundColor:
                        getCategoryColor(category).withOpacity(0.3),
                    animation: true,
                    animateFromLastPercent: true,
                  )
                ],
              );
            },
          )),
    );
  }
}
