import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/constants.dart';
import 'package:to_do/utils/helper.dart';

class CategoryCard extends StatelessWidget {
  final int taskCount;
  final int completedTaskCount;
  final Category category;

  CategoryCard({
    Key? key,
    required this.category,
    required this.taskCount,
    required this.completedTaskCount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(margin),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(
        width: 200.0,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$taskCount tasks',
                style: TextStyle(color: secondaryTextColor),
              ),
              Text(
                getCategoryName(category),
                style: TextStyle(fontSize: categoryFontSize),
              ),
              LinearPercentIndicator(
                percent: taskCount != 0 ? completedTaskCount / taskCount : 1.0,
                progressColor: getCategoryColor(category),
                backgroundColor: getCategoryColor(category).withOpacity(0.3),
                animation: true,
                animateFromLastPercent: true,
              )
            ],
          ),
        ),
      ),
    );
  }

  String getCategoryName(Category category) {
    switch (category) {
      case Category.PERSONAL:
        return 'Personal';
      case Category.WORK:
        return 'Work';
    }
  }
}
