import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  @override
  _CoursesScreenState createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to fetch courses from Firestore
  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    try {
      // Access the 'Courses/2023/courses' collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("Courses")
          .doc("2023")
          .collection("courses")
          .get();

      // Return the list of courses from the documents
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses found.'));
          }

          // Display list of courses in a DataTable
          List<Map<String, dynamic>> courses = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.vertical, // Allow vertical scrolling
            child: DataTable(
              columnSpacing: 16.0, // Space between columns
              columns: [
                DataColumn(
                  label: Container(
                    width: 100, // Set a fixed width for the column
                    child: Text(
                      'Course Code',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: 200, // Set a fixed width for the column
                    child: Text(
                      'Course Name',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: 100, // Set a fixed width for the column
                    child: Text(
                      'Credits',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                    ),
                  ),
                ),
              ],
              rows: courses.map((course) {
                return DataRow(cells: [
                  DataCell(Text(course['Course_Code'] ?? '')),
                  DataCell(Text(course['Course_Name'] ?? '')),
                  DataCell(Text(course['Credit'] ?? '')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
