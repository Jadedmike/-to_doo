import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/task_model.dart';

class AddPage extends StatefulWidget {
  final TaskModel? task;
  final int? index;

  const AddPage({super.key, this.task, this.index});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  // اللون الافتراضي للكرت
  Color selectedColor = Colors.blueAccent;

  // نفس ستايل الألوان يلي استخدمناه بالكروت
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

    // ✅ لو جايين بوضع "تعديل" (في task موجود)
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      selectedColor = Color(widget.task!.colorValue);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      // لو العنوان فاضي ما منساوي شي
      return;
    }

    final box = Hive.box<TaskModel>('tasksBox');

    if (widget.task == null) {
      // ✅ وضع الإضافة (تسك جديدة)
      final newTask = TaskModel(
        title: title,
        description: desc,
        isDone: false,
        colorValue: selectedColor.value,
      );
      box.add(newTask);
    } else {
      // ✅ وضع التعديل (نفس التسك – نحدّث قيمها ونحفظ)
      final existingTask = widget.task!;
      existingTask.title = title;
      existingTask.description = desc;
      existingTask.colorValue = selectedColor.value;
      existingTask.save(); // مهم
    }

    // منرجع على الهوم بيج
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Add Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان التسك
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // الوصف
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // عنوان اختيار اللون
            const Text(
              'Choose color',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // الألوان (دوائر صغيرة أفقية)
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: availableColors.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final color = availableColors[index];
                  final isSelected = color == selectedColor;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(width: 3, color: Colors.white)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Save Task',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
