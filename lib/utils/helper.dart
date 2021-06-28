import 'package:flutter/material.dart';
import 'package:to_do/utils/category.dart';
import 'package:to_do/utils/constants.dart';

Color getCategoryColor(Category category) {
  switch (category) {
    case Category.PERSONAL:
      return personalToDoColor;
    case Category.WORK:
      return workTodoColor;
  }
}
