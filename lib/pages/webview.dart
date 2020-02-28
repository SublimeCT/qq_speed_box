import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:qq_speed_box/utils/Application.dart';

class WebviewPage extends StatefulWidget {
  String url;
  String initTitle;
  WebviewPage(@required this.url, @required this.initTitle);

  @override
  _WebviewPageState createState() => _WebviewPageState(Uri.decodeComponent(url), Uri.decodeComponent(initTitle));
}

class _WebviewPageState extends State<WebviewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String url;
  String initTitle;
  _WebviewPageState(@required this.url, @required this.initTitle);

  @override
  void initState() {
    super.initState();
    _injectJs();
  }

  void dispose() {
    super.dispose();
    flutterWebviewPlugin.close();
  }

  _injectJs() async {
    String script = await rootBundle.loadString("assets/js/video_handler.js");
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      // Application.logger.d("注入 js ???");
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.evalJavascript(script);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Application.logger.d("加载 webview => $url");
    return WebviewScaffold(
      debuggingEnabled: true,
      userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.122 Safari/537.36',
      url: url,
      appBar: AppBar(
        title: Text(initTitle),
      ),
      withZoom: true,
      withLocalStorage: true,
      // hidden: true,
      initialChild: Container(
        color: Colors.redAccent,
        child: const Center(
          child: Text('Waiting.....'),
        ),
      ),
    );
  }
}