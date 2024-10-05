import 'package:attendalert/screens/courses.dart';
import 'package:attendalert/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  // Function to log out the user
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Navigator.pushReplacementNamed(context, '/login'); // Adjust the route name as needed
    } catch (e) {
      // Handle error (e.g., show a message)
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
            icon: Icon(Icons.logout),
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
                // Navigate to attendance screen or perform action
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
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
