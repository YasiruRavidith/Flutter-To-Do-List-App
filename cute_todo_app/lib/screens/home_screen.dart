import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../models/todo_model.dart';
import '../widgets/todo_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final userId = _authService.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFE8E4F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cute Todo List',
          style: TextStyle(
            color: Color(0xFF7B68EE),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF7B68EE)),
            onPressed: () => _authService.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Reminders Card
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildRemindersCard(userId),
          ),

          // Todo List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection('todos')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFB3BA),
                    ),
                  );
                }

                final todos = snapshot.data!.docs
                    .map((doc) => TodoItem.fromMap(
                          doc.id,
                          doc.data() as Map<String, dynamic>,
                        ))
                    .toList();

                if (todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Color(0xFFFFB3BA),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No todos yet!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add one',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodoCard(
                      todo: todos[index],
                      userId: userId!,
                      onToggle: () => _toggleTodoComplete(userId, todos[index]),
                      onDelete: () => _deleteTodo(userId, todos[index].id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context, userId!),
        backgroundColor: const Color(0xFFFFB3BA),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildRemindersCard(String? userId) {
    if (userId == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .orderBy('createdAt', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        final reminders = snapshot.hasData
            ? snapshot.data!.docs
            : [];

        return Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.local_florist,
                      size: 24,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Don't Forget!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFFFFB3BA)),
                    onPressed: () => _showAddReminderDialog(context, userId),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (reminders.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Tap + to add important reminders',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                ...reminders.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return _buildReminderItem(
                    userId,
                    doc.id,
                    data['text'] as String,
                    data['alarmTime'] as int?,
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReminderItem(String userId, String reminderId, String text, int? alarmTime) {
    final hasAlarm = alarmTime != null;
    final alarmDateTime = hasAlarm ? DateTime.fromMillisecondsSinceEpoch(alarmTime) : null;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB3BA),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                if (hasAlarm && alarmDateTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.alarm, size: 12, color: Color(0xFFFFB3BA)),
                        const SizedBox(width: 4),
                        Text(
                          '${alarmDateTime.hour.toString().padLeft(2, '0')}:${alarmDateTime.minute.toString().padLeft(2, '0')} ${alarmDateTime.day}/${alarmDateTime.month}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              hasAlarm ? Icons.alarm : Icons.alarm_add,
              size: 18,
              color: hasAlarm ? const Color(0xFFFFB3BA) : Colors.black38,
            ),
            onPressed: () => _setReminderAlarm(context, userId, reminderId, text, alarmDateTime),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.black38),
            onPressed: () => _deleteReminder(userId, reminderId),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  void _showAddReminderDialog(BuildContext context, String userId) {
    final reminderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.local_florist, color: Color(0xFF4CAF50)),
            SizedBox(width: 8),
            Text('Add Reminder'),
          ],
        ),
        content: TextField(
          controller: reminderController,
          decoration: InputDecoration(
            hintText: 'What should you remember?',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.lightbulb_outline),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reminderController.text.isNotEmpty) {
                _addReminder(userId, reminderController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB3BA),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addReminder(String userId, String text) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .add({
      'text': text,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'alarmTime': null,
    });
  }

  Future<void> _deleteReminder(String userId, String reminderId) async {
    // Cancel the notification if there's an alarm set
    final notificationId = reminderId.hashCode;
    await _notificationService.cancelAlarm(notificationId);
    
    // Delete from Firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminderId)
        .delete();
  }

  Future<void> _setReminderAlarm(BuildContext context, String userId, String reminderId, String text, DateTime? currentAlarm) async {
    final now = DateTime.now();
    DateTime selectedDateTime = currentAlarm ?? now;
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDateTime);

    // Show date picker
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.isAfter(now) ? selectedDateTime : now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFB3BA),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return;

    // Show time picker
    if (!context.mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFB3BA),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    // Combine date and time
    final alarmDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    // Update reminder with alarm time in Firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminderId)
        .update({
      'alarmTime': alarmDateTime.millisecondsSinceEpoch,
    });

    // Schedule the notification alarm
    final notificationId = reminderId.hashCode;
    await _notificationService.scheduleAlarm(
      id: notificationId,
      title: "Don't Forget!",
      body: text,
      scheduledTime: alarmDateTime,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm set for $text at ${pickedTime.format(context)} on ${pickedDate.day}/${pickedDate.month}'),
        backgroundColor: const Color(0xFF4CAF50),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context, String userId) {
    final titleController = TextEditingController();
    String selectedCat = categories[0].name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.add_task, color: Color(0xFF7B68EE)),
            SizedBox(width: 8),
            Text('Add New Todo'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'What do you need to do?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCat,
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat.name,
                  child: Row(
                    children: [
                      Icon(cat.icon, size: 20, color: cat.color),
                      const SizedBox(width: 8),
                      Text(cat.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => selectedCat = value!,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.category),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                _addTodo(userId, titleController.text, selectedCat);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB3BA),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _addTodo(String userId, String title, String category) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .add({
      'title': title,
      'category': category,
      'isCompleted': false,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> _toggleTodoComplete(String userId, TodoItem todo) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todo.id)
        .update({'isCompleted': !todo.isCompleted});
  }

  Future<void> _deleteTodo(String userId, String todoId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('todos')
        .doc(todoId)
        .delete();
  }
}