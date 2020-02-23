import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Image.asset("assets/images/splash_background.png"),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    "https://game.gtimg.cn/images/speed/web201503/img/inside_logo.png",
                    width: 100,
                  ),
                  Text(
                    "QQ Speed Box",
                    style: TextStyle(fontSize: 22),
                  ),
                  RaisedButton(
                    child: Text('fetch'),
                    onPressed: () {
                      Spider spider = Spider();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
