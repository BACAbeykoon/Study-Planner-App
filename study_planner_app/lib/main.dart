import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: StudyApp(), debugShowCheckedModeBanner: false));
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Study Planner"), centerTitle: true),
    );
  }
}
