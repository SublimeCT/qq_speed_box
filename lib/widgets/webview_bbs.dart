import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:qq_speed_box/utils/Application.dart';

class WebviewBBS extends StatefulWidget {
  String url = MOBILE_BBS_LINK;
  WebviewBBS([this.url]);
  @override
  _WebviewBBSState createState() => _WebviewBBSState(url = MOBILE_BBS_LINK);
}

class _WebviewBBSState extends State<WebviewBBS> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String title = '视频区';
  String _userAgent = USER_AGENT_MOBILE;
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

  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<String> _onUrlChanged;

  _WebviewBBSState(this._url);

  @override
  void initState() {
    super.initState();
    /// 处理 js 注入
    _injectJs();
    /// 检测是否跳转到腾讯视频播放页
    _listenReport();
  }

  _injectJs() async {
    String script = await rootBundle.loadString("assets/js/bbs_handler.js");
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      // Application.logger.d("注入 js ???");
      if (viewState.type == WebViewState.finishLoad) {
        flutterWebviewPlugin.evalJavascript(script);
      }
    });
  }

  _listenReport() async {
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      Application.logger.d('<webview> 页面监听到页面跳转, url: ' + url + ' UA: ' + _userAgent);
      // if (url.indexOf('https://v.qq.com/txp/iframe/player.html?vid') == 0 && _userAgent == USER_AGENT_MOBILE) {
      //   _userAgent = USER_AGENT_PC;
      //   setState(() {
      //     Future.microtask(() {
      //       flutterWebviewPlugin.evalJavascript("location.href = '${url}&ua_reload=1'");
      //     });
      //   });
      // } else {
      //   _userAgent = USER_AGENT_MOBILE;
      // }
    });
  }

  void dispose() {
    super.dispose();
    _onStateChanged.cancel();
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Application.logger.d("重新渲染了 webview 组件, 此时的 UA: $_userAgent");
    return WebviewScaffold(
        debuggingEnabled: true,
        userAgent: _userAgent,
        url: url,
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              tooltip: "主页",
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                flutterWebviewPlugin.evalJavascript("location.href='${MOBILE_BBS_LINK}'");
              },
            ),
            IconButton(
              tooltip: "后退",
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                flutterWebviewPlugin.goBack();
              },
            ),
            IconButton(
              tooltip: "前进",
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onPressed: () {
                flutterWebviewPlugin.goForward();
              },
            ),
            IconButton(
              tooltip: "清空缓存",
              icon: Icon(
                Icons.clear_all,
                color: Colors.white,
              ),
              onPressed: () {
                flutterWebviewPlugin.evalJavascript('localStorage.clear();document.cookie = "";');
              },
            ),
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
}