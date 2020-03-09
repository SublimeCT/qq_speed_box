import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qq_speed_box/pages/about.dart';
import 'package:qq_speed_box/pages/database.dart';
import 'package:qq_speed_box/pages/post.dart';
import 'package:qq_speed_box/pages/webview.dart';
import 'package:qq_speed_box/utils/Application.dart';

import 'package:qq_speed_box/pages/Index.dart';
import 'package:qq_speed_box/pages/splash.dart';

class Route {
  final String name;
  final String path;
  final String paramKey;
  final Widget Function(Map<String, dynamic>) page;
  final bool withParams;
  const Route(@required this.name, @required this.path, @required this.page,
      [this.withParams = false, this.paramKey]);

  /// 路由结构
  static Map<String, Route> routes = {
    "splash": Route(
      "splash",
      "/",
      (Map<String, dynamic> paramters) => SplashPage(),
    ),
    "index": Route(
      "index",
      "/index",
      (Map<String, dynamic> paramters) => IndexPage(),
    ),
    "videos": Route(
      "videos",
      "/videos",
      (Map<String, dynamic> paramters) => DatabasePage(),
    ),
    "post": Route("post", "/post/:id/:title", (Map<String, dynamic> paramters) {
      return PostPage(
        paramters['id'][0].toString(),
        paramters['title'][0].toString(),
      );
    }, true),
    "about": Route(
      "about",
      "/about",
      (Map<String, dynamic> paramters) => AboutPage(),
    ),
    "webview": Route("webview", "/webview/:url/:title",
        (Map<String, dynamic> paramters) {
      return WebviewPage(
        paramters['url'][0].toString(),
        paramters['title'][0].toString(),
      );
    }, true),
  };

  /// 注册路由
  static define(Router router) {
    routes.forEach((String name, Route route) {
      router.define(route.path,
          handler: Handler(
            handlerFunc:
                (BuildContext context, Map<String, dynamic> parameters) =>
                    route.page(parameters),
          ));
    });
  }
}

class Routes {
  /// 初始化路由
  static configureRoutes(Router router) {
    router.notFoundHandler = Handler(handlerFunc:
        (BuildContext context, Map<String, List<String>> parameters) {
      Application.logger.d("404 - ⚠️ not found!");
    });

    /// 注册路由
    Route.define(router);
  }
}
