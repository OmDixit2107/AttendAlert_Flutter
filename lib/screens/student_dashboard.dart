import 'package:attendalert/screens/AttendanceScreen.dart';
import 'package:attendalert/screens/auth.dart';
import 'package:attendalert/screens/classes_screen.dart';
import 'package:attendalert/screens/courses.dart';
import 'package:attendalert/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_dashboard.dart'; // Add Firebase Firestore import

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  String? rollNo;

  @override
  void initState() {
    super.initState();
    _fetchRollNo();
  }

  // Fetch the roll number from Firebase
  Future<void> _fetchRollNo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Assuming rollNo is stored as the first 9 characters of the email
        final rollNo = user.email!.substring(0, 9);
        setState(() {
          this.rollNo = rollNo;
        });
      }
    } catch (e) {
      print("Error fetching roll number: $e");
    }
  }

  // Function to log out the user
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Back"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            DashboardCard(
              title: "Attendance",
              icon: Icons.check_circle_outline,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => ClassesScreen()));
              },
            ),
            DashboardCard(
              title: "View Courses",
              icon: Icons.book_outlined,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => CoursesScreen()));
              },
            ),
            DashboardCard(
              title: "View Profile",
              icon: Icons.person_outline,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => Profile()));
              },
            ),
            DashboardCard(
              title: "Apply Leaves",
              icon: Icons.exit_to_app,
              onTap: () {
                // Navigate to apply leaves screen or perform action
              },
            ),
            DashboardCard(
              title: "Attendance Statistics",
              icon: Icons.bar_chart_outlined,
              onTap: () {
                if (rollNo != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AttendanceScreen(rollNo: rollNo!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Roll number is not available.")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
