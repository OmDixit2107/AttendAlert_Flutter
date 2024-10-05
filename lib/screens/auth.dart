import 'package:attendalert/screens/admin_dashboard.dart';
import 'package:attendalert/screens/student_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  var _islogin = true; // Toggle between login and signup
  var _email = ""; // Email input
  var _password = ""; // Password input
  String? _selectedRole; // Role selected from the dropdown
  final List<String> _roles = ['Admin', 'Student']; // List of roles
  bool _isLoading = false; // Track loading state

  final FirebaseAuth _fbauth = FirebaseAuth.instance; // Firebase Authentication instance

  // Function to handle form submission
 void _submit() async {
  if (_email.trim().isEmpty || _password.trim().isEmpty) {
    _showMessage("Email or password is empty");
    return;
  }
  if (!_email.endsWith("@iiitvadodara.ac.in")) {
    _showMessage("Only iiitvadodara.ac.in email addresses are allowed");
    return;
  }

  if (!_islogin && _selectedRole == null) {
    _showMessage("Please select a role");
    return;
  }

  setState(() {
    _isLoading = true;  // Start loading
  });

  try {
    if (_islogin) {
      // Log in
      UserCredential userCredential = await _fbauth.signInWithEmailAndPassword(
          email: _email, password: _password);

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Check the role from Firestore
      final role = userDoc.data()?['role'];

      if (role == 'Student') {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const StudentDashboardScreen()));
      } else if (role == 'Admin') {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const AdminDashboardScreen()));
      } else {
        _showMessage("Unknown role, please contact support.");
      }
    } else {
      // Sign up
      UserCredential _creds = await _fbauth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      final _id = _creds.user!.uid;

      // Save role in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_id)
          .set({'email': _email, 'role': _selectedRole});

      if (_selectedRole == 'Student') {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const StudentDashboardScreen()));
      } else if (_selectedRole == 'Admin') {
        Navigator.push(
            context, MaterialPageRoute(builder: (ctx) => const AdminDashboardScreen()));
      }
    }
  } catch (e) {
    _showMessage("Error during authentication: $e");
  } finally {
    setState(() {
      _isLoading = false;  // Stop loading
    });
  }
}


  // Function to show validation messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  "assets/iiitv_logo.png", // Add your IIITV logo here
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Attend Alert",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color(0xFF673AB7),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter your email",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (email) {
                    setState(() {
                      _email = email;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  onChanged: (password) {
                    setState(() {
                      _password = password;
                    });
                  },
                ),
                const SizedBox(height: 20),
                if (!_islogin)
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    hint: const Text("Select your role"),
                    items: _roles.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator() // Show loading spinner
                    : ElevatedButton(
                        onPressed: _isLoading ? null : _submit, // Disable button while loading
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: const Color(0xFF673AB7),
                        ),
                        child: Text(
                          _islogin ? "Login" : "Sign Up",
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _islogin = !_islogin;
                    });
                  },
                  child: Text(
                    _islogin
                        ? "Create a new account"
                        : "Already have an account? Log in",
                    style: const TextStyle(
                      color: Color(0xFF673AB7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
