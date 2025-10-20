import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final Map<String, dynamic>? oldTask;
  const AddPage({super.key, this.oldTask});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Color? selectedColor;

  final List<Color> availableColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.tealAccent,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.oldTask != null) {
      _titleController.text = widget.oldTask!['title'];
      _descController.text = widget.oldTask!['description'];
      selectedColor = widget.oldTask!['color'];
    }
  }

  void saveTask() {
    if (_titleController.text.trim().isEmpty) return;
    Navigator.pop(context, {
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'color': selectedColor ?? Colors.blueAccent,
      'isDone': widget.oldTask?['isDone'] ?? false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Choose Color:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: availableColors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: color,
                    child: selectedColor == color
                        ? const Icon(Icons.check, color: Colors.black)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 159, 83, 73),
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                'Save Task',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
