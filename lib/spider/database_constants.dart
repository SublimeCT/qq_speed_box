import 'package:flutter/material.dart';

/// 记录种类
enum RecordCategoryType {
  /// 赛道之王
  Track,

  /// 极限之王
  Limit,

  /// 极速之王
  TopSpeed,

  /// 飞驰之王
  Speed,

  /// 抓地之王
  Grasp,
}

/// 记录的种类描述
const Map<RecordCategoryType, String> RecordCategoryTypeMap = {
  RecordCategoryType.Track: "赛道之王",
  RecordCategoryType.Limit: "极限之王",
  RecordCategoryType.TopSpeed: "极速之王",
  RecordCategoryType.Speed: "飞驰之王",
  RecordCategoryType.Grasp: "抓地之王",
};

/// 赛车类型
enum CarType {
  A,
  B,
  C,
  D,
  S,
  T1,
  T2,
  T3,
}

/// 赛车类型描述
const Map<CarType, String> CarTypeMap = {
  CarType.A: "A车",
  CarType.B: "B车",
  CarType.C: "C车",
  CarType.D: "爵士",
  CarType.S: "S车",
  CarType.T1: "T1",
  CarType.T2: "T2",
  CarType.T3: "T3",
};

/// 记录数据的类目
class RecordCategory {

  /// 显示在 `/videos` 页面的顶部 `TabTar` 组件中的名称
  final String tabName;
  
  /// 类型
  final RecordCategoryType type;

  /// 赛车类型
  final CarType carType;

  /// 是否改装
  final bool retrofit;

  /// 是否开启宝石
  final bool gem;

  const RecordCategory(
      {@required this.type,
      @required this.carType,
      @required this.tabName,
      this.retrofit = true,
      this.gem = false});

  toString() {
    return "<${RecordCategoryTypeMap[type]} - ${CarTypeMap[carType]} - ${retrofit ? "🛠" : "❌🛠"} - ${gem ? "💎" : "❌💎"}>";
  }

  static const TrackD = const RecordCategory(type: RecordCategoryType.Track, carType: CarType.D, tabName: "赛王爵士", retrofit: false);
  static const TrackBR = const RecordCategory(type: RecordCategoryType.Track, carType: CarType.B, tabName: "赛王B改装");

  static const SpeedAR = const RecordCategory(type: RecordCategoryType.Speed, carType: CarType.D, tabName: "飞驰A改装有💎", gem: true);
  static const SpeedBR = const RecordCategory(type: RecordCategoryType.Speed, carType: CarType.B, tabName: "飞驰B改装有💎", gem: true);
  static const SpeedSRG = const RecordCategory(type: RecordCategoryType.Speed, carType: CarType.B, tabName: "飞驰S改装有💎", gem: true);

  static const LimitS = const RecordCategory(type: RecordCategoryType.Limit, carType: CarType.S, tabName: "极限S原装", retrofit: false);
  static const LimitSR = const RecordCategory(type: RecordCategoryType.Limit, carType: CarType.S, tabName: "极限S改装");

  static const TopSpeedA = const RecordCategory(type: RecordCategoryType.TopSpeed, carType: CarType.A, tabName: "极速A原装", retrofit: false);
  static const TopSpeedAR = const RecordCategory(type: RecordCategoryType.TopSpeed, carType: CarType.A, tabName: "极速A改装");

  static const GraspD = const RecordCategory(type: RecordCategoryType.Grasp, carType: CarType.D, tabName: "抓地爵士", retrofit: false);
  static const GraspS = const RecordCategory(type: RecordCategoryType.Grasp, carType: CarType.S, tabName: "抓地原装S", retrofit: false);
}

/// 可筛选的记录的类目集合
const List<RecordCategory> RecordCategoryList = [
  RecordCategory.TrackD,
  RecordCategory.TrackBR,
  RecordCategory.SpeedAR,
  RecordCategory.SpeedBR,
  RecordCategory.SpeedSRG,
  RecordCategory.LimitS,
  RecordCategory.LimitSR,
  RecordCategory.TopSpeedA,
  RecordCategory.TopSpeedAR,
  RecordCategory.GraspD,
  RecordCategory.GraspS,
];

/// 所有的视频链接种类
/// 
/// 整理过程中发现了官方论坛的链接极其混乱, 有的直接引用了原帖，甚至出现了拼写错误或有被恶意修改嫌疑的链接:
/// 
/// - http://121.207.251.159/playercs2008.swf
/// - https://speed.gamebbs.qq.com/file:///C:/Users/Administrator/Desktop/peed.qq.com/video3/detail.shtml?G_Biz=8&tid=258458&e_code=speedweb.searchiType.iType1121
/// - http://speed.gamebbs.qq.com/Splendid%E4%B8%B6Swag
/// - http://v.qq.com/error.html
/// - https://mail.qq.com/cgi-bin/loginpage?s=session_timeout&from=&r=b5f437a8d54f350051d3091a0332a177&tiptype=LOGIN_ERR_COOKIE_FORBIDDEN
/// - http://cache.tv.qq.com/qqplayerout.swf
/// 
/// 还有这些因无法访问所以无从考证的链接:
/// 
/// - http://58.22.102.90/playercs2008.swf?Flvid=1486261
/// 
/// ## 链接筛选脚本
/// 
/// ```javascript
/// var patterns = [
///     '/x/page',
///     'speed.qq.com/video3',
///     'speed.qq.com/v/detail',
///     'static.video.qq.com/TPout.swf',
///     'imgcache.qq.com/tencentvideo_v1',
///     'f.v.17173cdn.com/flash/PreloaderFileFirstpage.swf',
///     'speed.gamebbs.qq.com/forum.php',
///     'm.v.qq.com/play',
///     'v.qq.com/page',
///     'v.17173.com/v_1',
///     'speed.qq.com/v/go.shtml',
/// ]
/// document.querySelectorAll('a').forEach(d => {
///     if (d.innerText !== '赛道欣赏>>' || patterns.some(p => d.href.indexOf(p) > 0)) return;
///     console.log(d.href)
/// })
/// ```
///
enum VideoType {
  /// ## 腾讯视频官网
  /// such as: `https://v.qq.com/x/page/v0925j0int8.html`
  qq,
  /// ## 腾讯视频 `flash` 格式文件
  /// such as: `http://static.video.qq.com/TPout.swf?vid=j0176j69qf4&auto=0`
  qq_swf,
  /// ## 腾讯视频 `/x/x/x` 格式
  /// such as: `http://v.qq.com/page/q/i/y/q01976bupiy.html?ptag=v`
  qq_xxx,
  /// ## 腾讯视频 * 17173 合体格式
  /// such as: `http://speed.qq.com/v/go.shtml?G_Biz=8&tid=8570`
  qq_x_17173,
  /// ## qq飞车官网视频中心新版(`video3`)
  /// such as: `http://speed.qq.com/video3/detail.shtml?G_Biz=8&tid=1187148&e_code=speedweb.searchiSubType.iSubType1148`
  center_video3,
  /// ## qq飞车官网视频中心旧版(`detail`)
  /// such as: `http://speed.qq.com/v/detail.shtml?G_Biz=8&tid=7712`
  center_detail,
  /// ## imagecache `flash` 格式视频
  /// such as: `https://imgcache.qq.com/tencentvideo_v1/playerv3/TPout.swf?max_age=86400&v=20161117&vid=u03725tgd55&auto=0`
  image_cache_swf,
  /// ## 17173 视频 `swf` 格式
  /// such as: `http://f.v.17173cdn.com/flash/PreloaderFileFirstpage.swf?cid=MTUyODc3MjM&refer=http://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1466805&page=1&extra=`
  v17173,
  /// ## 17173 `v1` 版本视频
  /// such as: `http://v.17173.com/v_1_10520/MjE4OTQwMTk.html`
  v17173v1,
  /// ## 官方论坛
  /// **are you kidding me?**
  /// such as: `https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1701870&extra=page%3D7`
  bbs,
  /// ## 腾讯视频 `m.v.qq.com` 版本
  /// such as: `http://m.v.qq.com/play/play.html?coverid=&vid=z3024kyczxx&ptag=2_7.7.0.20412_copy`
  mv_qq,
}

abstract class VideoTypeHandler {
  VideoType type;
  bool validate(String url);
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id);
  /// 检测视频是否有效
  Future<bool> check();
}

class QQVideoTypeHandler {
  VideoType type = VideoType.qq;
  bool validate(String url) {
    return url.indexOf("v.qq.com/x/page") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class QQVideoXXXTypeHandler {
  VideoType type = VideoType.qq_xxx;
  bool validate(String url) {
    return url.indexOf("v.qq.com/page") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class CenterVideo3CenterVideoTypeHandler {
  VideoType type = VideoType.center_video3;
  bool validate(String url) {
    return url.indexOf("speed.qq.com/video3") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class CenterDetailVideoTypeHandler {
  VideoType type = VideoType.center_detail;
  bool validate(String url) {
    return url.indexOf("speed.qq.com/v/detail") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class QQSwfVideoTypeHandler {
  VideoType type = VideoType.qq_swf;
  bool validate(String url) {
    return url.indexOf("static.video.qq.com/TPout.swf") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class ImageCacheSwfVideoTypeHandler {
  VideoType type = VideoType.image_cache_swf;
  bool validate(String url) {
    return url.indexOf("imgcache.qq.com/tencentvideo_v1") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class VideoQQ17173TypeHandler {
  VideoType type = VideoType.qq_x_17173;
  bool validate(String url) {
    return url.indexOf("speed.qq.com/v/go.shtml") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class Video17173TypeHandler {
  VideoType type = VideoType.v17173;
  bool validate(String url) {
    return url.indexOf("f.v.17173cdn.com/flash/PreloaderFileFirstpage.swf") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class Video17173V1TypeHandler {
  VideoType type = VideoType.v17173v1;
  bool validate(String url) {
    return url.indexOf("v.17173.com/v_1") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class BBSTypeHandler {
  VideoType type = VideoType.bbs;
  bool validate(String url) {
    return url.indexOf("speed.gamebbs.qq.com/forum.php") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

class MVQQTypeHandler {
  VideoType type = VideoType.mv_qq;
  bool validate(String url) {
    return url.indexOf("m.v.qq.com/play") > 0;
  }
  /// 获取 id
  Future<String> getID(String url) { throw Exception("还没写"); }
  /// 根据 `getID()` 获取到的 `id` 生成链接
  Future<String> getUrlByID(String id) { throw Exception("还没写"); }
  /// 检测视频是否有效
  Future<bool> check() { throw Exception("还没写"); }
}

List<VideoTypeHandler> videoTypeHandler = [];

/// RecordCategory 对应的帖子 URL
// const Map<RecordCategoryType, String> ArticleURLMap = {
//   RecordCategoryType.Track: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663147',
//   RecordCategoryType.Speed: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1682060',
//   RecordCategoryType.Limit: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663287',
//   RecordCategoryType.TopSpeed: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1662762',
//   RecordCategoryType.Grasp: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663042',
// };
