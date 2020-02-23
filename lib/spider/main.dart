import 'package:flutter/material.dart';
import 'package:html/dom.dart' as Dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/utils/Application.dart';

/// (赛道所属)系列
/// 参考链接:
/// - [官网系列/地图列表](http://speed.qq.com/web201008/page/race.shtml)
class Series {
  final String name;
  final String banner;
  const Series({@required this.name, @required this.banner});

  static const Ice = Series(
      name: "冰天雪地",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=1&raceImg=race01.jpg");
  static const Sea = Series(
      name: "阳光海滨",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=2&raceImg=race02.jpg");
  static const Forest = Series(
      name: "暮色森林",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race03.jpg");
  static const Scenic = Series(
      name: "世界名胜",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race04.jpg");
  static const Chinese = Series(
      name: "中国风",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race05.jpg");
  static const Street = Series(
      name: "古典老街",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race06.jpg");
  static const City = Series(
      name: "现代城市",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race07.jpg");
  static const Space = Series(
      name: "太空城",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race08.jpg");
  static const Country = Series(
      name: "幻想国度",
      banner:
          "http://speed.qq.com/web201008/page/race_page.shtml?iTypeId=4&raceImg=race09.jpg");

  static List<Series> all = [
    Series.Ice,
    Series.Sea,
    Series.Forest,
    Series.Scenic,
    Series.Chinese,
    Series.Street,
    Series.City,
    Series.Space,
    Series.Country,
  ];

  static List<String> get allNameList => Series.all.map((Series s) => s.name);
}

/// 赛道
/// 参考链接:
/// - [官网地图列表](http://speed.qq.com/web201008/page/race.shtml)
class Track {
  final String name;
  final Series series;

  /// 赛道地图, 来自 [官网地图列表](http://speed.qq.com/web201008/page/race.shtml)
  final String mapImage;
  const Track({@required this.name, @required this.series, this.mapImage = ""});
  static Map<String, Track> all = {};

  /// 按名称获取地图, 不存在时创建
  static Track ensureGet({@required String name, @required Series series}) {
    String _name = name.trim();
    if (Track.all[_name] == null) {
      Track.all[_name] = Track(name: _name, series: series);
      print(_name);
    }
    return Track.all[_name];
  }
}

/// 视频
class Video {
  VideoType type;
  final String originUrl;
  String url;
  String id;
  bool valid;
  Video(
      {this.type,
      @required this.originUrl,
      this.url,
      this.id,
      this.valid = true});
  static List<Video> all = [];
  Future<void> getVideoInfo() async {
    /// load video info ...
  }
}

/// (视频)记录
class Record {
  final Track track;
  final String time;
  final String date;
  final String author;
  final Video video;
  const Record({
    @required this.track,
    @required this.time,
    @required this.date,
    @required this.video,
    @required this.author,
  });
  static List<Record> all = [];
  /// 用于比较的 `time` 值
  int get compareTime => int.parse(time.replaceAll('.', ''));
  @override
  String toString() {
    return "地图: ${track.name} | 记录: ${time} | 时间: ${date} | 作者: ${author} | 视频: ${video.originUrl}";
  }
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
    List<Future<void>> requestQueue =
        Article.all.map<Future<void>>((Article article) {
      final halder = () async => article.document = await article.fetch();
      return halder();
    }).toList();
    return Future.wait(requestQueue);
  }

  /// 开始处理数据
  /// 参考链接:
  /// - [List 常用 API 总结](https://blog.csdn.net/ffa_ijj/article/details/85051156)
  /// - [dartpad](https://dartpad.cn/)
  static handle() {
    /// 先清空记录
    Record.all.clear();

    /// 根据 `ArticleTable.all` 整理每条记录
    for (Article article in Article.all) {
      List<Dom.Element> tables = article.document.querySelectorAll('.t_table');

      /// 当前文章中包含的所有 table
      List<ArticleTable> currentTables =
          ArticleTable.all.where((ArticleTable at) => at.article == article).toList();
      for (ArticleTable at in currentTables) {
        Dom.Element table = tables[at.index];

        /// 填充 `Record.all`
        for (Dom.Element tr in table.querySelectorAll("tr")) {
          if (tr.children.length < 5) continue;
          /// 视频 URL
          Dom.Element a = tr.children[4].querySelector("a");
          if (a == null || a.attributes == null) continue;
          String originUrl = a.attributes['href'];
          Record.all.add(
            Record(
              track: Track.ensureGet(name: tr.children[0].text.trim(), series: at.series),
              time: tr.children[2].text.trim(),
              date: tr.children[1].text.trim(),
              author: tr.children[3].text.trim(),
              video: Video(
                originUrl: originUrl,
              ),
            ),
          );
        }
      }
    }
  }
}

class ArticleTable {
  final Article article;
  final RecordCategory category;
  final Series series;

  /// 当前 table 在 `.t_table` 所处位置
  final int index;

  const ArticleTable({
    @required this.article,
    @required this.category,
    @required this.series,
    @required this.index,
  });

  /// 所有帖子中包含的表格集合
  /// 手动整理自所有帖子, 这个结构应该不会发生变化, 除非原帖的结构改动;
  static List<ArticleTable> all = [
    /// 赛王
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Ice,
        index: 6),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Sea,
        index: 3),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Forest,
        index: 1),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Scenic,
        index: 9),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Chinese,
        index: 5),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Street,
        index: 4),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.City,
        index: 2),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Space,
        index: 8),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackD,
        series: Series.Country,
        index: 7),

    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Ice,
        index: 16),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Sea,
        index: 13),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Forest,
        index: 11),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Scenic,
        index: 19),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Chinese,
        index: 15),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Street,
        index: 14),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.City,
        index: 12),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Space,
        index: 18),
    ArticleTable(
        article: Article.TrackArticle,
        category: RecordCategory.TrackBR,
        series: Series.Country,
        index: 17),

    /// 飞驰
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Ice,
        index: 5),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Sea,
        index: 2),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Forest,
        index: 0),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Scenic,
        index: 8),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Chinese,
        index: 4),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Street,
        index: 3),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.City,
        index: 1),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Space,
        index: 7),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedAR,
        series: Series.Country,
        index: 6),

    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Ice,
        index: 15),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Sea,
        index: 12),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Forest,
        index: 10),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Scenic,
        index: 18),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Chinese,
        index: 14),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Street,
        index: 13),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.City,
        index: 11),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Space,
        index: 17),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedBR,
        series: Series.Country,
        index: 16),

    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Ice,
        index: 24),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Sea,
        index: 21),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Forest,
        index: 19),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Scenic,
        index: 27),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Chinese,
        index: 23),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Street,
        index: 22),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.City,
        index: 20),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Space,
        index: 26),
    ArticleTable(
        article: Article.SpeedArticle,
        category: RecordCategory.SpeedSRG,
        series: Series.Country,
        index: 25),

    /// 极限
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Ice,
        index: 5),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Sea,
        index: 2),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Forest,
        index: 0),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Scenic,
        index: 8),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Chinese,
        index: 4),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Street,
        index: 3),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.City,
        index: 1),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Space,
        index: 7),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Country,
        index: 6),

    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Ice,
        index: 14),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Sea,
        index: 11),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Forest,
        index: 9),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Scenic,
        index: 17),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Chinese,
        index: 13),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Street,
        index: 12),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.City,
        index: 10),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Space,
        index: 16),
    ArticleTable(
        article: Article.LimitArticle,
        category: RecordCategory.LimitS,
        series: Series.Country,
        index: 15),

    /// 极速
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Ice,
        index: 5),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Sea,
        index: 2),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Forest,
        index: 0),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Scenic,
        index: 8),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Chinese,
        index: 4),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Street,
        index: 3),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.City,
        index: 1),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Space,
        index: 7),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedA,
        series: Series.Country,
        index: 6),

    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Ice,
        index: 15),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Sea,
        index: 12),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Forest,
        index: 10),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Scenic,
        index: 18),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Chinese,
        index: 14),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Street,
        index: 13),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.City,
        index: 11),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Space,
        index: 17),
    ArticleTable(
        article: Article.TopSpeedArticle,
        category: RecordCategory.TopSpeedAR,
        series: Series.Country,
        index: 16),
  ];
}

class Spider {
  Spider() {
    this.launch();
  }
  launch() async {
    await Article.fetchAll();
    await Article.handle();
    // Track.all.keys.forEach((String k) {
    //   print(k);
    // });
  }
}
