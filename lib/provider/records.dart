import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/spider/main.dart';

/// 记录相关数据
class RecordsModel with ChangeNotifier {
  /// 记录列表
  List<Record> _records = [];
  List<Record> get records => _records;
  /// 爬取 records
  Future<void> fetchRecords() async {
    Spider spider = Spider();
    await spider.launch();
    _records = Record.all;
    notifyListeners();
  }
  /// track struct data, same to `Track.all`
  Map<String, Track> _tracks = {};
  Map<String, Track> get tracks => _tracks;
  void updateTracks(Map<String, Track> tracks) {
    _tracks = tracks;
    notifyListeners();
  }
  List<Record> getRecordsWhere({RecordCategory recordCategory , Series series}) {
    return _records.where((Record r) {
      bool categoryRight = recordCategory != null && r.category == recordCategory;
      bool seriesRight = series != null && r.track.series == series;
      return categoryRight && seriesRight;
    }).toList();
  }
}