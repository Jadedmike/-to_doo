import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final Map<String, dynamic>? task;

  const AddPage({super.key, this.task});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
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

    _titleController = TextEditingController(
      text: widget.task != null ? widget.task!['title'] ?? '' : '',
    );

    _descController = TextEditingController(
      text: widget.task != null ? widget.task!['description'] ?? '' : '',
    );

    if (widget.task != null && widget.task!['color'] != null) {
      selectedColor = widget.task!['color'] as Color;
    } else {
      selectedColor = availableColors.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void saveTask() {
    if (_titleController.text.trim().isEmpty) return;

    final bool isDoneOld = widget.task != null
        ? (widget.task!['isDone'] ?? false)
        : false;

    Navigator.pop(context, {
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'color': selectedColor ?? Colors.blueAccent,
      'isDone': isDoneOld,
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        centerTitle: true,
      ),
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
              label: Text(
                isEditing ? 'Save Changes' : 'Save Task',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
