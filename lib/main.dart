import 'package:flutter/material.dart';
import 'package:flutter_demo/home.dart';
import 'package:flutter_demo/login.dart';
import 'package:flutter_demo/task_details.dart';
import 'package:flutter_demo/task_list.dart';

const applicationId = '1sf2WqiGhWjAGb7iV2QPz67uIp526EhkgP84jHt5';
const clientKey = 'PTBwlVVQ20l8hJM4jlro3l0F8DCUj26N8gl6k57c';
const parseURL = 'https://parseapi.back4app.com';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Buddy',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/tasks': (context) => const TaskList(),
        '/view-details': (context) => const TaskDetails(),
      },
    );
  }
}
