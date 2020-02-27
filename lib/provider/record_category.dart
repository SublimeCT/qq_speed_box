import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/database_constants.dart';

/// 当前(在 `/database` 页面)选择的记录的类目信息
class RecordCategoryModel with ChangeNotifier {
  /// 当前选择的 `RecordCategory` index
  int _categoryIndex = 0;
  RecordCategory get category => RecordCategoryList[_categoryIndex];
  int get categoryIndex => _categoryIndex;
  void changeCategory(int index) {
    _categoryIndex = index;
    notifyListeners();
  }
}