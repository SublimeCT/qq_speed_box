import 'package:flutter/material.dart';
import 'package:html/dom.dart' as Dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/utils/Application.dart';

/// (赛道所属)系列
class Series {
  final String name;
  const Series({@required this.name});
  static List<Series> all = [];
  static fromArticle() {}
}

/// 赛道
/// 参考链接:
/// - [官网地图列表](http://speed.qq.com/web201008/page/race.shtml)
class Track {
  final String name;
  const Track({@required this.name});
  static List<Track> all = [];
}

/// 视频
class Video {
  final VideoType type;
  final String originUrl;
  final String url;
  final String id;
  final bool valid;
  const Video(
      {@required this.type,
      @required this.originUrl,
      @required this.url,
      @required this.id,
      this.valid = true});
  static List<Video> all = [];
}

/// (视频)记录
class Record {
  final Track track;
  final int time;
  final String date;
  final Video video;
  const Record({
    @required this.track,
    @required this.time,
    @required this.date,
    @required this.video,
  });
  static List<Record> all = [];
}

/// 帖子
class Article {
  final String url;
  final RecordCategoryType type;
  Dom.Document document;
  Article({@required this.type, @required this.url, this.document});

  static Article TrackArticle = Article(
      type: RecordCategoryType.Track,
      url: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663147');
  static Article SpeedArticle = Article(
      type: RecordCategoryType.Speed,
      url: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1682060');
  static Article LimitArticle = Article(
      type: RecordCategoryType.Limit,
      url: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663287');
  static Article TopSpeedArticle = Article(
      type: RecordCategoryType.TopSpeed,
      url: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1662762');
  static Article GraspArticle = Article(
      type: RecordCategoryType.Grasp,
      url: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663042');

  static List<Article> all = [
    Article.TrackArticle,
    Article.SpeedArticle,
    Article.LimitArticle,
    Article.TopSpeedArticle,
    Article.GraspArticle,
  ];

  Future<Dom.Document> fetch() async {
    http.Response res = await http.get(url, headers: {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.116 Safari/537.36'
    });
    if (res.statusCode != 200) {
      Application.logger.e("获取帖子数据失败");
      throw Exception("获取帖子数据失败");
    }
    return parse(res.body);
  }

  /// 开始获取数据
  static Future fetchAll() {
    List<Future<void>> requestQueue = Article.all.map<Future<void>>((Article article) {
      final halder = () async => article.document = await article.fetch();
      return halder();
    }).toList();
    return Future.wait(requestQueue);
  }

  /// 开始处理数据
  static handle() {
    List<Dom.Element> banners = Article.TrackArticle.document.querySelectorAll("ignore_js_op > img");
    banners.forEach((Dom.Element banner) {
      Application.logger.d("赛王帖子内的 banner 图片" + banner.attributes['title']);
    });
  }
}

class Spider {
  Spider() {
    this.launch();
  }
  launch() async {
    await Article.fetchAll();
    await Article.handle();
  }
}
