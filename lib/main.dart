import 'package:attendalert/core/di/injection_container.dart';
import 'package:flutter/material.dart';

void main() {
  //perform asynchronous operations before calling runApp()
  WidgetsFlutterBinding.ensureInitialized();
  configureDependicies();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
