import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  final String rollNo;

  const AttendanceScreen({required this.rollNo, Key? key}) : super(key: key);

  /// Fetches attendance records for all subjects of a specific roll number.
  Future<Map<String, List<Map<String, dynamic>>>> _fetchAttendance(
      String currentUserUID) async {
    final firestore = FirebaseFirestore.instance;
    final Map<String, List<Map<String, dynamic>>> attendanceRecords = {};

    try {
      // Replace with your known subcollection names
      final subcollections = ['EC201', 'EC261','MA201','CS201','CS261','CS203','CS263','SC201','HS201'];

      // Loop through each subcollection
      for (final subject in subcollections) {
        final querySnapshot = await firestore
            .collection('attendanceRecords')
            .doc(currentUserUID)
            .collection(subject)
            .get();

        // Extract data and group it by subject
        attendanceRecords[subject] = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      print('Error fetching attendance: $e');
    }

    return attendanceRecords;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Records"),
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _fetchAttendance(rollNo),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No attendance records found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final attendanceData = snapshot.data!;

          return ListView.builder(
            itemCount: attendanceData.keys.length,
            itemBuilder: (context, index) {
              final className = attendanceData.keys.elementAt(index);
              final records = attendanceData[className]!;

              return Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 3,
                child: ExpansionTile(
                  title: Text(
                    className,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                  children: records.map((record) {
                    final rawDate = record['date'] ?? "Unknown Date";
                    final time = record['time'] ?? "Unknown Time";
                    final status = record['status'] ?? "Unknown Status";

                    // Format the date
                    String formattedDate;
                    try {
                      final parsedDate = DateTime.parse(rawDate);
                      formattedDate = DateFormat('MMMM dd, yyyy').format(parsedDate);
                    } catch (e) {
                      formattedDate = "Invalid Date";
                    }

                    return ListTile(
                      title: Text(
                        "Date: $formattedDate, Time: $time",
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        "Status: $status",
                        style: TextStyle(
                          fontSize: 14,
                          color: status.toLowerCase() == "present"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      leading: Icon(
                        Icons.calendar_today,
                        color: Colors.blueAccent,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
