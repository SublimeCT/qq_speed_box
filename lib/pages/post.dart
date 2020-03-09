import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final String id;
  final String title;
  const PostPage(this.id, this.title);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Uri.decodeComponent(widget.title), style: TextStyle(fontSize: 18),),
      ),
      body: Text('test'),
    );
  }
}