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
      this.retrofit = true,
      this.gem = false});

  static const TrackD = const RecordCategory(type: RecordCategoryType.Track, carType: CarType.D, retrofit: false);
  static const TrackBR = const RecordCategory(type: RecordCategoryType.Track, carType: CarType.B);

  static const SpeedAR = const RecordCategory(type: RecordCategoryType.Speed, carType: CarType.D);
  static const SpeedBR = const RecordCategory(type: RecordCategoryType.Speed, carType: CarType.B);
  static const SpeedSRG = const RecordCategory(type: RecordCategoryType.Speed, carType: CarType.B, gem: true);

  static const LimitS = const RecordCategory(type: RecordCategoryType.Limit, carType: CarType.S, retrofit: false);
  static const LimitSR = const RecordCategory(type: RecordCategoryType.Limit, carType: CarType.S);

  static const TopSpeedA = const RecordCategory(type: RecordCategoryType.TopSpeed, carType: CarType.A, retrofit: false);
  static const TopSpeedAR = const RecordCategory(type: RecordCategoryType.TopSpeed, carType: CarType.A);

  static const GraspD = const RecordCategory(type: RecordCategoryType.Grasp, carType: CarType.D, retrofit: false);
  static const GraspS = const RecordCategory(type: RecordCategoryType.Grasp, carType: CarType.S, retrofit: false);
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

enum VideoType {
  qq,
  qq_video_center,
  v17173,
}

/// RecordCategory 对应的帖子 URL
// const Map<RecordCategoryType, String> ArticleURLMap = {
//   RecordCategoryType.Track: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663147',
//   RecordCategoryType.Speed: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1682060',
//   RecordCategoryType.Limit: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663287',
//   RecordCategoryType.TopSpeed: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1662762',
//   RecordCategoryType.Grasp: 'https://speed.gamebbs.qq.com/forum.php?mod=viewthread&tid=1663042',
// };
