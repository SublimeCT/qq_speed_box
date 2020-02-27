import 'package:bot_toast/bot_toast.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:qq_speed_box/pages/splash.dart';
import 'package:qq_speed_box/routes/routes.dart';
import 'package:qq_speed_box/utils/Application.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    // 初始化路由
    Application.router = Router();
    Routes.configureRoutes(Application.router);
  }
  
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: SplashPage(),
      )
    );
  }
}
