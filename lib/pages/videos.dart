import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/spider/main.dart';
import 'package:qq_speed_box/wigets/record_category_tabbar.dart';
import 'package:qq_speed_box/wigets/topbar.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage>
    with
        AutomaticKeepAliveClientMixin<VideosPage>,
        SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        TabController(vsync: this, length: RecordCategoryList.length);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: RecordCategoryList.length,
      child: Column(
        children: <Widget>[
          Material(
            elevation: 10,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      TopBar(),
                      TabBar(
                        indicatorColor: Colors.white,
                        labelStyle: TextStyle(fontSize: 15),
                        unselectedLabelStyle: TextStyle(fontSize: 14),
                        isScrollable: true,
                        controller: _tabController,
                        tabs: _buildTabs(),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ],
      ),
    );
  }

  List<Tab> _buildTabs() {
    return RecordCategoryList.map<Tab>(
      (RecordCategory category) => Tab(
        text: category.tabName,
      ),
    ).toList();
  }

  List<Container> _buildTabViews() {
    return RecordCategoryList.map<Container>(
      (RecordCategory category) => Container(
        child: Text(category.tabName),
      ),
    ).toList();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
