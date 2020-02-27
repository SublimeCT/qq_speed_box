import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qq_speed_box/provider/records.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/spider/main.dart';
import 'package:qq_speed_box/utils/Application.dart';

class RecordList extends StatefulWidget {
  RecordCategory category;
  RecordList({Key key, @required this.category}) : super(key: key);
  @override
  _RecordListState createState() => _RecordListState();
}

class _RecordListState extends State<RecordList>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      controller: _scrollController,
      children: Series.all
          .map((Series s) => SeriesTile(series: s, category: widget.category))
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SeriesTile extends StatelessWidget {
  Series series;
  RecordCategory category;
  SeriesTile({Key key, @required this.series, @required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(series.banner),
          fit: BoxFit.fitWidth,
          alignment: Alignment.topLeft,
        ),
      ),
      child: ExpansionTile(
        // key: GlobalKey(),
        title: Container(
          color: Colors.transparent,
          height: 80,
        ),
        children: Provider.of<RecordsModel>(context)
            .getRecordsWhere(recordCategory: category, series: series)
            .map((Record record) => RecordTail(record))
            .toList(),
      ),
    );
  }
}

class RecordTail extends StatelessWidget {
  Record record;
  RecordTail(@required this.record);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 40,
                alignment: Alignment.center,
                child: Text(record.track.name, style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
              Text(record.author, textAlign: TextAlign.right, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54)),
            ],
          ),
          Row(
            children: <Widget>[
              Text(record.time, style: TextStyle(fontSize: 25, color: Colors.orange, fontWeight: FontWeight.w300)),
              InkWell(
                onTap: () => Application.router.navigateTo(context, "/webview/${Uri.encodeComponent(record.video.originUrl)}/${Uri.encodeComponent(record.track.name)}"),
                child: Icon(Icons.play_circle_outline, size: 40,)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
