import 'package:flutter/material.dart';
import 'pages/home/home_page.dart';

void main() {
  runApp(const ToDoList());
}

class ToDoList extends StatelessWidget {
  const ToDoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDoList',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}
