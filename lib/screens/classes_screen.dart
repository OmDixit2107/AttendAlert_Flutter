import 'package:attendalert/services/location_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Location Validator
  final LocationValidator _locationValidator = LocationValidator(
    geofenceLatitude: 23.216939559116362,
    geofenceLongitude: 72.69860516838112,
    geofenceRadius: 50, // 50 meters radius
  );

  String ?_rollNo;
  var _currentDay="Monday";
  @override
  void initState() {
    super.initState();
    _fetchRollNo();
  }
  void _setCurrentDay() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final now = DateTime.now();
    _currentDay = days[now.weekday -1]; // `weekday` returns 1 for Monday, etc.
    setState(() {}); // Update UI to reflect the current day
  }

  Future<void> _fetchRollNo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) {
        throw Exception("User is not logged in or email is unavailable.");
      }
      final rollNo = user.email!.substring(0, 9);
      setState(() {
        _rollNo = rollNo;
      });
    } catch (e) {
      print("Error fetching roll number: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchClassesAndLabs(String day) async {

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("Classes")
          .doc("2023")
          .collection(day)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching classes and labs: $e');
      return [];
    }
  }

  Future<void> _validateAndMarkAttendance({
    required String rollNo,
    required String className,
    required bool isPresent,
  }) async {
    try {
      // Validate geofence for "Present" attendance
      if (isPresent) {
        final isWithinGeofence = await _locationValidator.isWithinGeofence();
        if (!isWithinGeofence) {
          _showMessage("You are outside the geofence. Cannot mark attendance.");
          return;
        }
      }

      // Mark attendance in Firestore
      await _markAttendance(
        rollNo: rollNo,
        className: className,
        attendanceDate: DateTime.now(),
        isPresent: isPresent,
      );

      final message = isPresent
          ? "Attendance marked as Present."
          : "Attendance marked as Absent.";
      _showMessage(message);
    } catch (e) {
      _showMessage("Error: $e");
    }
  }

  Future<void> _markAttendance({
    required String rollNo,
    required String className,
    required DateTime attendanceDate,
    required bool isPresent,
  }) async {
    try {
      final attendanceRef = _firestore
          .collection('attendanceRecords')
          .doc(rollNo)
          .collection(className)
          .doc();

      final attendanceData = {
        'rollNo': rollNo,
        'className': className,
        'date': attendanceDate.toIso8601String(),
        'time': '${attendanceDate.hour}:${attendanceDate.minute}',
        'status': isPresent ? 'Present' : 'Absent',
      };

      await attendanceRef.set(attendanceData);
    } catch (e) {
      print('Error marking attendance: $e');
      throw e;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentDay();
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes and Labs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchClassesAndLabs(_currentDay),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No classes or labs found.'));
          }

          List<Map<String, dynamic>> classesAndLabs = snapshot.data!;
          if (_rollNo == null) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: classesAndLabs.length,
            itemBuilder: (context, index) {
              var record = classesAndLabs[index];
              String className = record['Class Name'] ?? 'Unknown Class';
              if(className=="Unknown Class"){
                className= record['Lab Name']?? 'Unknown Class';
              }
              String time = record['Time'] ?? 'Unknown Time';

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    className,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Time: $time',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _validateAndMarkAttendance(
                          rollNo: _rollNo!,
                          className: className,
                          isPresent: true,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Present'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _validateAndMarkAttendance(
                          rollNo: _rollNo!,
                          className: className,
                          isPresent: false,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Absent'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
