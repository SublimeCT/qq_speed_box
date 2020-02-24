import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qq_speed_box/pages/about.dart';
import 'package:qq_speed_box/pages/videos.dart';
import 'package:qq_speed_box/utils/Application.dart';

import 'package:qq_speed_box/pages/Index.dart';
import 'package:qq_speed_box/pages/splash.dart';

class Route {
  final String name;
  final String path;
  final String description;
  final Widget Function() page;
  const Route(@required this.name, @required this.path, @required this.page,
      [this.description]);

  /// 路由结构
  static Map<String, Route> routes = {
    "splash": Route("splash", "/", () => SplashPage()),
    "index": Route("index", "/index", () => IndexPage()),
    "videos": Route("videos", "/videos", () => VideosPage()),
    "about": Route("about", "/about", () => AboutPage()),
  };

  /// 注册路由
  static define(Router router) {
    routes.forEach((String name, Route route) {
      router.define(route.path,
          handler: Handler(
            handlerFunc:
                (BuildContext context, Map<String, List<String>> parameters) =>
                    route.page(),
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
