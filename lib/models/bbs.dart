import 'dart:collection';

import 'package:flutter/material.dart';

class BBSArticleState {}

class BBSArticle {
  static final String defaultTitleColor = '666666';
  static final RegExp idPattern = RegExp(r'tid=(\d)+');
  static final RegExp uidPattern = RegExp(r'uid=(\d)+');
  static final RegExp lastPagePattern = RegExp(r'\.\.\.\s+(\d{1,7})');
  final String id;

  /// article link, such as https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1706139&extra=page%3D1
  final String link;
  final String title;
  final String authorName;
  final String authorID;
  final String createdAt;
  final String replay;
  final String watch;
  final String lastReplaier;
  final String lastReplaierID;
  final String lastReplayTime;
  final String category;
  final String titleColor;

  BBSArticle(
      {@required this.id,
      @required this.link,
      @required this.title,
      @required this.authorName,
      @required this.authorID,
      @required this.createdAt,
      @required this.replay,
      @required this.watch,
      this.lastReplaier,
      this.lastReplaierID,
      this.lastReplayTime,
      this.titleColor,
      @required this.category});
  String get authorAvatar => BBSArticle.getAvatar(authorID);
  String get lastReplierAvatar => BBSArticle.getAvatar(lastReplaierID);
  Color get titleColorVal {
    return Color(int.parse(titleColor, radix: 16) + 0xFF000000);
  }
  static String getAvatar(String id) =>
      "https://ucenter.gamebbs.qq.com/avatar.php?uid=${id}&size=big";
  static String getArticleURL(int page) =>
      "https://speed.gamebbs.qq.com/forum.php?mod=forumdisplay&fid=30673&page=${page}";
  static String getIdByLink(String _link) {
    if (_link == null) return '';
    String idPart = idPattern.stringMatch(_link);
    return idPart == null ? '' : idPart.substring(4);
  }

  static String getAuthorIdByLink(String _link) {
    if (_link == null) return '';
    String idPart = uidPattern.stringMatch(_link);
    return idPart == null ? '' : idPart.substring(4);
  }

  static LinkedHashMap<String, BBSArticle> all = LinkedHashMap();
  /// 总页数
  static int pageCount = 0;
}

/// 帖子
/// such as: https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1706398
class BBSPost {
  String tid;
  String url;
  String get cover => "TODO";
}

/// 帖子中的回帖
class BBSPostReply {
  /// 楼主
  BBSAuthor author;
}

/// 论坛用户信息
class BBSAuthor {
  /// 主要信息(列表页和帖子页显示)

  final String id;
  final String name;
  final String avator;

  /// 次要信息(赛王帖子页显示)

  /// 类似于 qq 等级, 即 ![](https://res.gamebbs.qq.com/static/image/common/star_level2.gif) 表示 `4` 级; ![](https://res.gamebbs.qq.com/static/image/common/star_level1.gif) 表示 `1` 级
  int rank;
  /// 积分
  int integral;

  /// 详细信息(详情页显示)

  /// 用户组, 例如: 玩家审核版主
  String groupName;
  /// 个人签名, 用户自定义内容
  String signature;
  /// 回帖数
  int replyCount;
  /// 主题帖数
  int postCount;
  String qq;
  /// 个人主页
  String homePage;
  String sex;
  String realName;
  String education;
  String school;
  /// 职业
  String job;
  /// 在线时间
  String onlineTime;
  /// 注册时间
  String createdAt;
  /// 最后访问时间
  String lastTiem;


  BBSAuthor(this.id, this.name, this.avator);
}
