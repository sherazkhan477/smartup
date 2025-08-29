import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'db_helper.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Insert default user
  await DBHelper.insertUser('student@example.com', '123456');

  // Load JSON file
  final String categoriesJson = await rootBundle.loadString(
    'assets/categories.json',
  );
  final String jobsJson = await rootBundle.loadString('assets/jobs.json');

  final List<dynamic> categoriesList = jsonDecode(categoriesJson);
  final List<dynamic> jobsList = jsonDecode(jobsJson);

  final dbHelper = DBHelper();

  // Insert categories if table empty
  final categoriesCount = await DBHelper.database.then(
    (db) => db.rawQuery('SELECT COUNT(*) FROM categories'),
  );
  if (categoriesCount.isEmpty || categoriesCount.first.values.first == 0) {
    for (var cat in categoriesList) {
      await DBHelper.insertCategory(cat);
    }
  }

  // Insert jobs if table empty
  final jobsCount = await DBHelper.database.then(
    (db) => db.rawQuery('SELECT COUNT(*) FROM jobs'),
  );
  if (jobsCount.isEmpty || jobsCount.first.values.first == 0) {
    for (var job in jobsList) {
      await DBHelper.insertJob(job);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Prototype',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
