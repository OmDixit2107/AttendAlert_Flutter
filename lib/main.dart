import 'package:attendalert/screens/auth.dart';
import 'package:attendalert/screens/admin_dashboard.dart';
import 'package:attendalert/screens/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(ProviderScope(child: MyApp()));  // Wrap with ProviderScope for Riverpod
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultHome = const Auth();  // Default is the Auth screen

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();  // Check if user is logged in
  }

  // Function to check if the user is logged in and redirect accordingly
  void _checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;  // Get the current user
    if (user != null) {
      // User is logged in, get their role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = userDoc.data()?['role'];

      if (role == 'Student') {
        setState(() {
          _defaultHome = const StudentDashboardScreen();  // Redirect to Student Dashboard
        });
      } else if (role == 'Admin') {
        setState(() {
          _defaultHome = const AdminDashboardScreen();  // Redirect to Admin Dashboard
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attend Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _defaultHome,  // Show the determined default home (Auth or Dashboard)
    );
  }
}
