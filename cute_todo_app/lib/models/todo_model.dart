import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String title;
  String category;
  bool isCompleted;
  DateTime createdAt;
  String? dueDate;
  String? dueTime;

  TodoItem({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.dueTime,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'dueDate': dueDate,
      'dueTime': dueTime,
    };
  }

  // Create from Firestore document
  factory TodoItem.fromMap(String id, Map<String, dynamic> map) {
    return TodoItem(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? 'general',
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      dueDate: map['dueDate'],
      dueTime: map['dueTime'],
    );
  }
}

class Category {
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Predefined categories with cute Material Icons
final List<Category> categories = [
  Category(name: 'Pet Care', icon: Icons.pets, color: const Color(0xFFFFB3BA)),
  Category(name: 'Shopping', icon: Icons.shopping_bag, color: const Color(0xFFBAE1FF)),
  Category(name: 'Appointment', icon: Icons.calendar_today, color: const Color(0xFFFFDFBA)),
  Category(name: 'Reading', icon: Icons.menu_book, color: const Color(0xFFB9FBC0)),
  Category(name: 'Grocery', icon: Icons.local_grocery_store, color: const Color(0xFFFFFABA)),
  Category(name: 'Entertainment', icon: Icons.tv, color: const Color(0xFFFFB3E6)),
  Category(name: 'Chores', icon: Icons.cleaning_services, color: const Color(0xFFE0BBE4)),
  Category(name: 'Exercise', icon: Icons.directions_run, color: const Color(0xFFC7CEEA)),
];