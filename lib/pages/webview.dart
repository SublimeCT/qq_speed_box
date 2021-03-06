import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/utils/Application.dart';
import 'package:video_player/video_player.dart';

class WebviewPage extends StatefulWidget {
  String url;
  String initTitle;
  WebviewPage(this.url, this.initTitle);

  @override
  _WebviewPageState createState() => _WebviewPageState(
      Uri.decodeComponent(url), Uri.decodeComponent(initTitle));
}

class _WebviewPageState extends State<WebviewPage> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  VideoPlayerController _videoPlayerController;
  final String _reportUrlPrefix = 'https://v.qq.com/video_url/';
  String _url;
  String get url {
    if (_url != null &&
        _url.indexOf(
                'http://f.v.17173cdn.com/flash/PreloaderFileFirstpage.swf?cid=') ==
            0) {
      RegExp idMatchPattern = RegExp(r'\?cid=(\d|\w)+');
      String res = idMatchPattern.stringMatch(_url);
      if (res != null && res.length > 5) return "http://v.17173.com/player_ifrm2/${res.substring(5)}.html";
      return _url;
    } else {
      return _url;
    }
  }

  set url(u) => _url = u;
  String initTitle;

  /// webview 中视频加载完毕时上报的视频真实地址
  String _videoUrl;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  _WebviewPageState(this._url, this.initTitle);

  @override
  void initState() {
    super.initState();

    /// 处理 js 注入
    _injectJs();

    /// 监听上报的视频真实地址
    _listenReport();
  }

  void dispose() {
    super.dispose();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    _videoPlayerController?.dispose();
    flutterWebviewPlugin.dispose();
  }

  _injectJs() async {
    String script = await rootBundle.loadString("assets/js/video_handler.js");
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      // Application.logger.d("注入 js ???");
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.evalJavascript(script);
      }
    });
  }

  _listenReport() async {
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String videoUrl) {
      Application.logger.d('<webview> 页面监听到页面跳转, url: ' + videoUrl);
      if (videoUrl.indexOf('https://video_url.js.cn/') != 0) return;
      flutterWebviewPlugin.close();
      setState(() {
        _videoUrl = videoUrl.substring(_reportUrlPrefix.length);
        _videoPlayerController = VideoPlayerController.network(_videoUrl)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        Application.logger.d('<webview> 页面收到上报的视频真实地址, url: ' + _videoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoUrl != null
        ? _buildVideoPlayer()
        : WebviewScaffold(
            debuggingEnabled: true,
            userAgent:
                USER_AGENT_PC,
            url: url,
            appBar: AppBar(
              title: Text(initTitle),
              actions: <Widget>[
                IconButton(
                  tooltip: "刷新",
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    flutterWebviewPlugin.reload();
                  },
                ),
                IconButton(
                  tooltip: "复制链接",
                  icon: Icon(
                    Icons.link,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: url));
                    BotToast.showText(text: "copy successful");
                  },
                ),
              ],
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

  Widget _buildVideoPlayer() {
    return Scaffold(
      appBar: AppBar(
        title: Text(initTitle),
        actions: <Widget>[],
      ),
      body: Center(
        child: _videoPlayerController.value.initialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )
            : Container(),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: Row(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  _videoPlayerController.value.isPlaying
                      ? _videoPlayerController.pause()
                      : _videoPlayerController.play();
                });
              },
              child: Icon(
                _videoPlayerController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
