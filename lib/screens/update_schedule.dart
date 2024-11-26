import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UpdateScheduleScreen extends StatefulWidget {
  @override
  _UpdateScheduleScreenState createState() => _UpdateScheduleScreenState();
}

class _UpdateScheduleScreenState extends State<UpdateScheduleScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _selectedDay;
  List<Map<String, dynamic>> _schedule = [];
  bool _isLoading = false;

  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  Future<void> _fetchSchedule(String day) async {
    setState(() => _isLoading = true);
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('Schedules')
          .doc('2023')
          .collection(day)
          .get();

      setState(() {
        _schedule = snapshot.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList();
      });
    } catch (e) {
      print("Error fetching schedule: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update Schedule")),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedDay,
            hint: Text('Select Day'),
            items: days.map((day) {
              return DropdownMenuItem(value: day, child: Text(day));
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedDay = value);
              if (value != null) {
                _fetchSchedule(value);
              }
            },
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
            child: ListView.builder(
              itemCount: _schedule.length,
              itemBuilder: (context, index) {
                final schedule = _schedule[index];
                return ListTile(
                  title: Text(schedule['subject'] ?? 'No Subject'),
                  subtitle: Text("Time: ${schedule['time'] ?? 'N/A'} | Room: ${schedule['room'] ?? 'N/A'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Implement edit functionality
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implement delete functionality
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open a form to add a new schedule
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
