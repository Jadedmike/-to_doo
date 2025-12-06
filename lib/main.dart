import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/task_model.dart';
import 'pages/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TaskModelAdapter());

  await Hive.openBox<TaskModel>('tasksBox');

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
