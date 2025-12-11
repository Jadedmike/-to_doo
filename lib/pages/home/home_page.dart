import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/pages/add_page.dart';
import 'package:todo_list/pages/widgets/list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<TaskModel> tasksBox;

  @override
  void initState() {
    super.initState();
    tasksBox = Hive.box<TaskModel>('tasksBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ToDo List'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: tasksBox.listenable(),
        builder: (context, Box<TaskModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No tasks yet, add one!'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: box.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final task = box.getAt(index)!;

              return TodoListTile(
                title: task.title,
                description: task.description,
                color: Color(task.colorValue),
                isDone: task.isDone,
                onChanged: (value) {
                  task.isDone = value ?? false;
                  task.save();
                },
                onEdit: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddPage(task: task, index: index),
                    ),
                  );
                },
                onDelete: () {
                  box.deleteAt(index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPage(task: null, index: -1),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
