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
