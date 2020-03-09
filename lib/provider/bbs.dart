import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:qq_speed_box/models/bbs.dart';
import 'package:qq_speed_box/spider/main.dart';

/// 记录相关数据
class BBSModel with ChangeNotifier {
  int get pageCount => BBSArticle.pageCount;
  int _page = 0;
  int get page => _page;
  Spider _spider;
  Spider get spider {
    if (_spider == null) _spider = new Spider();
    return _spider;
  }
  bool get isPadding => _spider.state == SpiderState.Padding;
  /// 记录列表
  List<BBSArticle> get articleList => BBSArticle.all.keys.map<BBSArticle>((String id) => BBSArticle.all[id]).toList();
  /// 爬取 records
  Future<void> fetchArticles([int customPage]) async {
    await spider.loadArticles(customPage ?? ++_page);
    notifyListeners();
  }
}