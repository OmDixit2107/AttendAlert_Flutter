import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeaveRequestScreen extends StatefulWidget {
  @override
  _LeaveRequestScreenState createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  final TextEditingController _professorEmailController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;



  Future<void> _submitLeaveRequest() async {
    if (_professorEmailController.text.isEmpty ||
        _reasonController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }
    // Get the current authenticated user's email
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to fetch current user email.")),
      );
      return;
    }

    final studentEmail = user.email!;
    try {
      setState(() {
        _isSubmitting = true;
      });

      await FirebaseFirestore.instance.collection('leaverequests').add({
        'studentEmail': studentEmail, // Replace with dynamic user email
        'professorEmail': _professorEmailController.text.trim(),
        'reason': _reasonController.text.trim(),
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'status': "Pending",
      });
      await FirebaseFirestore.instance.collection('leaveapprovals').add({
        'studentEmail': studentEmail, // Replace with dynamic user email
        'professorEmail': _professorEmailController.text.trim(),
        'reason': _reasonController.text.trim(),
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
        'status': "Pending",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Leave request submitted successfully!")),
      );

      // Clear inputs
      _professorEmailController.clear();
      _reasonController.clear();
      setState(() {
        _startDate = null;
        _endDate = null;
      });
    } catch (e) {
      print("Error submitting leave request: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit leave request.")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Leave'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _professorEmailController,
              decoration: InputDecoration(
                labelText: 'Professor Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Reason for Leave',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                    child: Text(
                      _startDate == null
                          ? "Select Start Date"
                          : "Start: ${_startDate!.toLocal()}".split(' ')[0],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                    child: Text(
                      _endDate == null
                          ? "Select End Date"
                          : "End: ${_endDate!.toLocal()}".split(' ')[0],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _isSubmitting
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submitLeaveRequest,
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }
}
