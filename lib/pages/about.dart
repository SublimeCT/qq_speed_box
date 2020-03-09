import 'package:flutter/material.dart';
import 'package:qq_speed_box/spider/database_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              "https://game.gtimg.cn/images/speed/web201503/img/inside_logo.png",
              width: 220,
            ),
            FlatButton(
              color: Colors.black12,
              child: Text('Repository (GitHub)'),
              onPressed: () async {
                if (await canLaunch(GITHUB_URL)) {
                  launch(GITHUB_URL);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
