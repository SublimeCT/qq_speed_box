import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qq_speed_box/models/bbs.dart';
import 'package:qq_speed_box/provider/bbs.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/utils/Application.dart';
import 'package:qq_speed_box/widgets/post.dart';
import 'package:url_launcher/url_launcher.dart';

class BBSList extends StatefulWidget {
  @override
  _BBSListState createState() => _BBSListState();
}

class _BBSListState extends State<BBSList> {
  bool _firstFetch = false;
  ScrollController _postController;

  @override
  void initState() {
    super.initState();
    _postController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: BBSListTitle(),
        actions: <Widget>[
          IconButton(
            tooltip: "刷新",
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              BotToast.showText(text: '正在获取最新的帖子 ...');
              if (Provider.of<BBSModel>(context, listen: false).isPadding) return;
              Provider.of<BBSModel>(context, listen: false).fetchArticles(1);
              _postController.jumpTo(0);
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
          IconButton(
            tooltip: "复制链接",
            icon: Icon(
              Icons.open_in_browser,
              color: Colors.white,
            ),
            onPressed: () async {
              final bool _canLaunch = await canLaunch(MOBILE_BBS_LINK);
              if (_canLaunch) launch(MOBILE_BBS_LINK);
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, BBSModel bbs, Widget widget) {
          if (!_firstFetch) {
            /// 加载
            Provider.of<BBSModel>(context).fetchArticles();
            // 加载下一页
            _postController.addListener(() {
              if (_postController.position.pixels == _postController.position.maxScrollExtent) {
                BotToast.showText(text: '加载中 ...');
                if (Provider.of<BBSModel>(context, listen: false).isPadding) return;
                Provider.of<BBSModel>(context, listen: false).fetchArticles();
              }
            });
            _firstFetch = true;
          }
          return Container(
            child: Scrollbar(
              child: ListView.builder(
                controller: _postController,
                itemCount: Provider.of<BBSModel>(context).articleList.length,
                itemBuilder: (BuildContext context, int index) {
                  BBSArticle article =
                      Provider.of<BBSModel>(context).articleList[index];
                  return Post(article: article);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class BBSListTitle extends StatefulWidget {
  @override
  _BBSListTitleState createState() => _BBSListTitleState();
}

class _BBSListTitleState extends State<BBSListTitle> {
  String get pageInfo {
    return Provider.of<BBSModel>(context).page.toString() + ' / ' + Provider.of<BBSModel>(context).pageCount.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Text("视频区 ($pageInfo)");
  }
}