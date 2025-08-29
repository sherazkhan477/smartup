import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final IconData icon;

  Category({required this.id, required this.name, required this.icon});

  factory Category.fromMap(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: Icons.home, // placeholder (can map icons later if needed)
    );
  }
}
