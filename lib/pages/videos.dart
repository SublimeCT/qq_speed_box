import 'package:flutter/material.dart';
import 'package:qq_speed_box/widgets/webview_bbs.dart';

class VideosPage extends StatefulWidget {
  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Videos"),),
      body: Container(
        color: Colors.white70,
        child: WebviewBBS(),
      ),
    );
  }
}