import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qq_speed_box/models/bbs.dart';
import 'package:qq_speed_box/provider/bbs.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/utils/Application.dart';
import 'package:qq_speed_box/widgets/post.dart';

class BBSList extends StatefulWidget {
  @override
  _BBSListState createState() => _BBSListState();
}

class _BBSListState extends State<BBSList> {
  bool _firstFetch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('视频区'),
        actions: <Widget>[
          IconButton(
            tooltip: "刷新",
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              Application.logger.d('刷新视频区帖子');
            },
          ),
          IconButton(
            tooltip: "复制链接",
            icon: Icon(
              Icons.link,
              color: Colors.white,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: MOBILE_BBS_LINK));
              BotToast.showText(text: "copy successful");
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, BBSModel bbs, Widget widget) {
          if (!_firstFetch) {
            /// 加载
            Provider.of<BBSModel>(context).fetchArticles();
            _firstFetch = true;
          }
          return Container(
            child: ListView.builder(
              itemCount: Provider.of<BBSModel>(context).articleList.length,
              itemBuilder: (BuildContext context, int index) {
                BBSArticle article =
                    Provider.of<BBSModel>(context).articleList[index];
                return Post(article: article);
              },
            ),
          );
        },
      ),
    );
  }
}
