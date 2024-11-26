import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAttendanceScreen extends StatefulWidget {
  @override
  _ViewAttendanceScreenState createState() => _ViewAttendanceScreenState();
}

class _ViewAttendanceScreenState extends State<ViewAttendanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> subjects = [
    'EC201',
    'EC261',
    'MA201',
    'CS201',
    'CS261',
    'CS203',
    'CS263',
    'SC201',
    'HS201',
  ];

  final TextEditingController _rollNoController = TextEditingController();
  List<String> _subjects = [];
  String? _selectedSubject;
  Map<String, List<Map<String, dynamic>>> _attendanceRecords = {};
  bool _isLoading = false;

  Future<void> _fetchSubjectsAndAttendance(String rollNo) async {
    try {
      setState(() {
        _isLoading = true;
        _subjects.clear();
        _selectedSubject = null;
        _attendanceRecords.clear();
      });

      Map<String, List<Map<String, dynamic>>> fetchedAttendance = {};

      for (final subject in subjects) {
        final querySnapshot = await _firestore
            .collection('attendanceRecords')
            .doc(rollNo)
            .collection(subject)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          fetchedAttendance[subject] = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
        }
      }

      setState(() {
        _subjects = fetchedAttendance.keys.toList();
        _attendanceRecords = fetchedAttendance;
      });

      if (_subjects.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No attendance records found for this roll number.")));
      }
    } catch (e) {
      print("Error fetching attendance: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error fetching attendance: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Attendance'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _rollNoController,
              decoration: InputDecoration(
                labelText: 'Enter Roll Number',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final rollNo = _rollNoController.text.trim();
                    if (rollNo.isNotEmpty) {
                      _fetchSubjectsAndAttendance(rollNo);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a valid roll number.")));
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildDropdownAndAttendance(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownAndAttendance() {
    return Expanded(
      child: Column(
        children: [
          if (_subjects.isNotEmpty)
            DropdownButton<String>(
              value: _selectedSubject,
              hint: Text('Select Subject'),
              items: _subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value!;
                });
              },
            ),
          if (_selectedSubject != null)
            Expanded(
              child: ListView(
                children: (_attendanceRecords[_selectedSubject] ?? [])
                    .map((record) => ListTile(
                  title: Text("Date: ${record['date']}"),
                  subtitle: Text("Status: ${record['status']}"),
                ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
