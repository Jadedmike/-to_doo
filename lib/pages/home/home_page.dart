import 'package:flutter/material.dart';
import 'package:todo_list/pages/add_page.dart';
import 'package:todo_list/pages/widgets/list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];

  void addTask(Map<String, dynamic> newTask) {
    setState(() {
      tasks.add(newTask);
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void toggleDone(int index) {
    setState(() {
      tasks[index]['isDone'] = !tasks[index]['isDone'];
    });
  }

  void editTask(int index, Map<String, dynamic> updatedTask) {
    setState(() {
      tasks[index] = updatedTask;
    });
  }

  void showTaskOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomListTile(
                tasks: tasks,
                index: index,
                toggleDone: (int i) => this.toggleDone(i),
                editTask: (int i, Map<String, dynamic> updatedTask) =>
                    this.editTask(i, updatedTask),
                deleteTask: (int i) => this.deleteTask(i),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks yet...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                itemCount: tasks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return GestureDetector(
                    onTap: () => showTaskOptions(index),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: task['color'],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              task['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: task['isDone']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (task['isDone'])
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPage(task: {})),
          );
          if (newTask != null) addTask(newTask);
        },
        backgroundColor: Colors.tealAccent[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
