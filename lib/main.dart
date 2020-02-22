import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qq_speed_box/pages/splash.dart';
import 'package:qq_speed_box/routes/routes.dart';
import 'package:qq_speed_box/spider/main.dart';
import 'package:qq_speed_box/utils/Application.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    // 请求主页数据
    // Application.
    Spider spider = Spider();
    // 初始化路由
    Application.router = Router();
    Routes.configureRoutes(Application.router);
  }
  
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}
