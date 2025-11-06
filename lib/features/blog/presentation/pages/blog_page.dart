import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog App"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.add_circled)),
        ],
      ),

      body: Column(children: []),
    );
  }
}
