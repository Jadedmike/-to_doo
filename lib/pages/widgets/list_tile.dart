import 'package:flutter/material.dart';

class TodoListTile extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final bool isDone;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoListTile({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.isDone,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showOptionsBottomSheet(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDone ? Colors.grey[800] : color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            title,
            textAlign: TextAlign.center, // **النص بالنص**
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDone ? Colors.white54 : Colors.white,
              decoration: isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          subtitle: description.isEmpty
              ? null
              : Text(
                  description,
                  textAlign: TextAlign.center, // **كمان بالنص**
                  style: TextStyle(
                    fontSize: 14,
                    color: isDone ? Colors.white38 : Colors.white70,
                  ),
                ),
          trailing: Checkbox(value: isDone, onChanged: onChanged),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.check, color: Colors.tealAccent),
                title: Text(
                  isDone ? 'Unmark as done' : 'Mark as done',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  onChanged(!isDone);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.amberAccent),
                title: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
