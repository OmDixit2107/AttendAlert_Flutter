import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AdminLeaveDashboard extends StatelessWidget {
  final String professorEmail; // Pass dynamically for the professor logged in.

  AdminLeaveDashboard({required this.professorEmail});

  Future<void> _updateLeaveStatus(
      String leaveRequestId, Map<String, dynamic> leaveData, String status) async {
    try {
      // Update status in `leaverequests`
      await FirebaseFirestore.instance
          .collection('leaverequests')
          .doc(leaveRequestId)
          .update({'status': status});

      await FirebaseFirestore.instance
          .collection('leaveapprovals')
          .doc(leaveRequestId)
          .update({'status': status});
    } catch (e) {
      print("Error updating leave status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Leaves'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaverequests')
            .where('professorEmail', isEqualTo: professorEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return Center(child: Text("No leave requests found."));
          }

          return ListView(
            children: requests.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text("Student: ${data["studentEmail"]}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reason: ${data['reason']}"),
                    Text("Dates: ${data['startDate']} - ${data['endDate']}"),
                    Text("Status: ${data['status']}"),
                  ],
                ),
                trailing: data['status'] == "Pending"
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _updateLeaveStatus(doc.id, data, "Approved");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        _updateLeaveStatus(doc.id, data, "Rejected");
                      },
                    ),
                  ],
                )
                    : Icon(
                  data['status'] == "Approved"
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: data['status'] == "Approved"
                      ? Colors.green
                      : Colors.red,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
