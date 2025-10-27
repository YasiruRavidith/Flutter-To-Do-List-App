import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final String userId;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoCard({
    Key? key,
    required this.todo,
    required this.userId,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Find the category for this todo
    final category = categories.firstWhere(
      (cat) => cat.name == todo.category,
      orElse: () => categories[0],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Category Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              category.icon,
              size: 22,
              color: category.color,
            ),
          ),
          const SizedBox(width: 12),

          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFFB3BA),
                  width: 2,
                ),
                color: todo.isCompleted
                    ? const Color(0xFFFFB3BA)
                    : Colors.transparent,
              ),
              child: todo.isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          
          // Todo Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: todo.isCompleted
                        ? Colors.black45
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  todo.category,
                  style: TextStyle(
                    fontSize: 11,
                    color: category.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (todo.dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${todo.dueDate} ${todo.dueTime ?? ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Delete Button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Todo?'),
                  content: const Text('Are you sure you want to delete this todo?'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}