import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qq_speed_box/models/bbs.dart';
import 'package:qq_speed_box/utils/Application.dart';

class Post extends StatelessWidget {
  BBSArticle article;
  final double avatarSize;
  final double titleLabelSize;
  final double statRowItemSize;
  double get authorLabelSize => titleLabelSize;
  double get createdAtLabelSize => titleLabelSize - 2;

  Post(
      {@required this.article,
      this.avatarSize = 50,
      this.titleLabelSize = 16,
      this.statRowItemSize = 16});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 7),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[200])),
        ),
        child: Column(
          children: <Widget>[
            _buildAuthor(),
            _buildPost(),
            _buildStat(),
          ],
        ),
      ),
      onTap: () {
        print('点击进入帖子: ' + article.link);
        // Application.router.navigateTo(
        //   context,
        //   "/post/${Uri.encodeComponent(article.id)}/${Uri.encodeComponent(article.title)}",
        // );
        Application.router.navigateTo(
          context,
          "/webview/${Uri.encodeComponent(article.link)}/${Uri.encodeComponent(article.title)}",
        );
      },
    );
  }

  Widget _buildAuthor() {
    return Row(
      children: <Widget>[
        /// 头像
        Container(
          width: avatarSize,
          height: avatarSize,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white38, width: 2),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6.0),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                article.authorAvatar,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                article.authorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: authorLabelSize,
                ),
              ),
              Text(
                article.createdAt,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: createdAtLabelSize, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPost() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.cyanAccent, width: 1),
              color: Colors.cyan.withAlpha(130)
            ),
            padding: EdgeInsets.fromLTRB(6, 0, 6, 3),
            margin: EdgeInsets.only(right: 5),
            child: Text(
              article.category,
              style: TextStyle(fontSize: titleLabelSize, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              article.title,
              maxLines: 2,
              style: TextStyle(fontSize: titleLabelSize, fontWeight: FontWeight.w600, color: article.titleColorVal),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildStat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.reply,
          color: Colors.black38,
          size: statRowItemSize,
          semanticLabel: "回复数",
        ),
        Text(article.replay, style: TextStyle(color: Colors.black38,),),
        SizedBox(width: 20,),
        Icon(
          Icons.textsms,
          color: Colors.black38,
          size: statRowItemSize,
          semanticLabel: "查看数",
        ),
        Text(article.watch, style: TextStyle(color: Colors.black38,),),
      ],
    );
  }
}
