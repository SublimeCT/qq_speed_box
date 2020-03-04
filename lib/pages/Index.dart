import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qq_speed_box/pages/about.dart';
import 'package:qq_speed_box/pages/database.dart';
import 'package:qq_speed_box/pages/videos.dart';
import 'package:qq_speed_box/provider/bbs.dart';
import 'package:qq_speed_box/provider/record_category.dart';
import 'package:qq_speed_box/provider/records.dart';
import 'package:qq_speed_box/spider/main.dart';
import 'package:qq_speed_box/utils/Application.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  bool fetchRecords = false;

  final List<Widget> bodyPageList = [
    VideosPage(),
    DatabasePage(),
    AboutPage(),
  ];
  final List<BottomNavigationBarItem> bottomNavigationBarItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.ondemand_video), title: Text("videos")),
    BottomNavigationBarItem(
        icon: Icon(Icons.format_list_bulleted), title: Text("database")),
    BottomNavigationBarItem(
        icon: Icon(Icons.info_outline), title: Text("about")),
  ];

  final PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RecordCategoryModel>(
          create: (_) => RecordCategoryModel(),
        ),
        ChangeNotifierProvider<RecordsModel>(
          create: (_) => RecordsModel(),
        ),
        ChangeNotifierProvider<BBSModel>(
          create: (_) => BBSModel(),
        ),
      ],
      child: Scaffold(
        /// [使用 PageView 实现 keep alive](https://zhuanlan.zhihu.com/p/58582876)
        body: Consumer(
          builder: (BuildContext context, RecordsModel recordsModel, Widget widget) {
            if (!fetchRecords) {
              CancelFunc _cancelFunc;
              BotToast.showCustomLoading(toastBuilder: (CancelFunc cancelFunc) {
                _cancelFunc = cancelFunc;
                return Text('Loading ...');
              });
              Provider.of<RecordsModel>(context).fetchRecords().then((_) => _cancelFunc());
            }
            fetchRecords = true;
            return PageView(
              controller: pageController,
              onPageChanged: _onpageChanged,
              children: bodyPageList,
              physics: NeverScrollableScrollPhysics(),
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavigationBarItems,
          currentIndex: currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onpageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
