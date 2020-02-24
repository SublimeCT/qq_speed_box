import 'package:flutter/material.dart';
import 'package:qq_speed_box/pages/about.dart';
import 'package:qq_speed_box/pages/videos.dart';
import 'package:qq_speed_box/utils/Application.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<Widget> bodyPageList = [
    VideosPage(),
    AboutPage(),
  ];
  final List<BottomNavigationBarItem> bottomNavigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.ondemand_video), title: Text("videos")),
    BottomNavigationBarItem(icon: Icon(Icons.info_outline), title: Text("about")),
  ];
  final PageController pageController = PageController();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// [使用 PageView 实现 keep alive](https://zhuanlan.zhihu.com/p/58582876)
      body: PageView(
        controller: pageController,
        onPageChanged: _onpageChanged,
        children: bodyPageList,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigationBarItems,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
    Application.logger.d("[Index page] 切换页面 -> " + index.toString());
  }
  void _onpageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}