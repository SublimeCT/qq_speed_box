import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qq_speed_box/provider/records.dart';
import 'package:qq_speed_box/spider/main.dart';
import 'package:qq_speed_box/utils/Application.dart';

class TopBar extends StatefulWidget {
  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                BotToast.showText(text: "敬请期待");
              },
              child: Container(
                height: 32,
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Colors.white30),
                child: Text(
                  "click to search",
                  style: TextStyle(color: Colors.white54),
                ),
              )
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              tooltip: "敬请期待",
              icon: Icon(Icons.collections, color: Colors.white),
              onPressed: () {
                BotToast.showText(text: "敬请期待");
              },
            ),
          ),
        ],
      ),
    );
  }
}
