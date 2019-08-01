import 'package:flutter/material.dart';

class KnowledgePage extends StatefulWidget {
  KnowledgePage({Key key}) : super(key: key);

  _KnowledgePageState createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('知识体系')),
      body: Container(
        child: Center(child: Text('知识体系页面'),),
      ), 
    );
  }
}