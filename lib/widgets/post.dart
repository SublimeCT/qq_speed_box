import 'package:flutter/material.dart';
import 'package:qq_speed_box/models/bbs.dart';

class Post extends StatelessWidget {
  BBSArticle article;
  final double avatarSize;
  final double titleLabelSize;
  final double statRowItemSize;
  double get authorLabelSize => titleLabelSize;
  double get createdAtLabelSize => titleLabelSize - 2;

  Post(
      {@required this.article, this.avatarSize = 50, this.titleLabelSize = 16, this.statRowItemSize = 14});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          children: <Widget>[
            _buildAuthor(),
            _buildPost(),
            _buildStat(),
          ],
        ),
      ),
      onTap: () {
        print('点击进入帖子: ' + article.id);
      },
    );
  }

  Widget _buildAuthor() {
    return Row(
      children: <Widget>[
        /// 头像
        Image.network(
          article.authorAvatar,
          width: avatarSize,
          height: avatarSize,
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
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyanAccent, width: 1),
          ),
          child: Text(
            article.category,
            style: TextStyle(fontSize: titleLabelSize),
          ),
        ),
        Expanded(
          child: Text(
            article.title,
            style: TextStyle(fontSize: titleLabelSize),
          ),
        ),
      ],
    );
  }

  Widget _buildStat() {
    return Row(
      children: <Widget>[
        Icon(Icons.reply, size: statRowItemSize, semanticLabel: "回复数",),
        Text(article.replay),
        Icon(Icons.textsms, size: statRowItemSize, semanticLabel: "查看数",),
        Text(article.watch),
      ],
    );
  }
}
