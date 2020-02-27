import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/spider/main.dart';
import 'package:qq_speed_box/widgets/record_category_tabbar.dart';
import 'package:qq_speed_box/widgets/record_list.dart';
import 'package:qq_speed_box/widgets/topbar.dart';

class DatabasePage extends StatefulWidget {
  DatabasePage(): super(key: GlobalKey());
  @override
  _DatabasePageState createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage>
    with
        AutomaticKeepAliveClientMixin<DatabasePage>,
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
                    ],
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

  List<Widget> _buildTabViews() {
    return RecordCategoryList.map<Widget>(
      (RecordCategory category) => RecordList(category: category),
    ).toList();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
