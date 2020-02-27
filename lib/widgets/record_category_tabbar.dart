import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/spider/main.dart';

class RecordCategoryTabBar extends StatefulWidget {
  @override
  _RecordCategoryTabBarState createState() => _RecordCategoryTabBarState();
}

class _RecordCategoryTabBarState extends State<RecordCategoryTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: _buildTabs(),
    );
  }

  List<Tab> _buildTabs() {
    return Article.all
        .map<Tab>((Article article) => Tab(
              text: RecordCategoryTypeMap[article.type],
            ))
        .toList();
  }
}
