import 'package:flutter/material.dart';
import 'package:to_do/utils/constants.dart';

enum Category { PERSONAL, WORK }

List<String> _categoryImage = [
  'images/personal.png',
  'images/work.png',
];

List<String> _categoryNames = [
  'Person',
  'Work',
];

String getCategoryImageName(Category category) =>
    _categoryImage[category.index];

String getCategoryName(Category category) => _categoryNames[category.index];

Color getCategoryColor(Category category) {
  switch (category) {
    case Category.PERSONAL:
      return personalToDoColor;
    case Category.WORK:
      return workTodoColor;
  }
}
