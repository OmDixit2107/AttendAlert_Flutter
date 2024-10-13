import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch classes and labs from Firestore
  Future<List<Map<String, dynamic>>> _fetchClassesAndLabs() async {
    try {
      // Access the 'Classes/2023/Monday' collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("Classes")
          .doc("2023")
          .collection("Monday")
          .get();

      // Return the list of classes and labs from the documents
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching classes and labs: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes and Labs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchClassesAndLabs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No classes or labs found.'));
          }

          // Display list of classes and labs in a ListView
          List<Map<String, dynamic>> classesAndLabs = snapshot.data!;
          return ListView.builder(
            itemCount: classesAndLabs.length,
            itemBuilder: (context, index) {
              var record = classesAndLabs[index];
              String className = record['Class Name'] ?? 'Unknown Class';
              String time = record['Time'] ?? 'Unknown Time'; // Get Time from Firestore

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
                        onPressed: () {
                          // Placeholder for marking present
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Present'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Placeholder for marking absent
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
