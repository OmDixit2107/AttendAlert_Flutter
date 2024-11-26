import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentLeaveStatus extends StatelessWidget {
  final String studentEmail;

  StudentLeaveStatus({required this.studentEmail});

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return isoDate; // Fallback to the original format if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Leave Status'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leaverequests')
            .where('studentEmail', isEqualTo: studentEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final approvals = snapshot.data!.docs;

          if (approvals.isEmpty) {
            return Center(child: Text("No leave requests found."));
          }

          return ListView(
            children: approvals.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final formattedStartDate = _formatDate(data['startDate']);
              final formattedEndDate = _formatDate(data['endDate']);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text("Reason: ${data['reason']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dates: $formattedStartDate - $formattedEndDate"),
                      Text("Status: ${data['status']}"),
                      Text("Professor: ${data['professorEmail']}"),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
