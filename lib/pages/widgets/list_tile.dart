import 'package:flutter/material.dart';
import '../add_page.dart';

class CustomListTile extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final int index;
  final Function(int) toggleDone;
  final Function(int, Map<String, dynamic>) editTask;
  final Function(int) deleteTask;

  const CustomListTile({
    Key? key,
    required this.tasks,
    required this.index,
    required this.toggleDone,
    required this.editTask,
    required this.deleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.check, color: Colors.tealAccent),
          title: Text(
            tasks[index]['isDone'] ? 'Unmark as done' : 'Mark as done',
            style: const TextStyle(color: Colors.white),
          ),
          onTap: () {
            toggleDone(index);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit, color: Colors.amberAccent),
          title: const Text('Edit', style: TextStyle(color: Colors.white)),
          onTap: () async {
            Navigator.pop(context);
            final updatedTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddPage(task: tasks[index])),
            );

            if (updatedTask != null) {
              editTask(index, updatedTask);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.redAccent),
          title: const Text('Delete', style: TextStyle(color: Colors.white)),
          onTap: () {
            deleteTask(index);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
