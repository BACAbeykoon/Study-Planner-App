import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/Elements/colors.dart';
import 'package:study_planner_app/models/assignment_model.dart';
import 'package:study_planner_app/services/databases/assignment_service.dart';
import 'package:study_planner_app/widgets/countdowntimer.dart';

class AssignmentPage extends StatelessWidget {
  const AssignmentPage({super.key});

  Future<Map<String, List<Assignment>>> _fetchAssignments() async {
    return await AssignmentService().getAssignmentsWithCourseName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assignments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: FutureBuilder<Map<String, List<Assignment>>>(
        future: _fetchAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No assignments available.'));
          }

          final assignmentsMap = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: assignmentsMap.keys.length,
            itemBuilder: (context, index) {
              final courseName = assignmentsMap.keys.elementAt(index);
              final assignments = assignmentsMap[courseName]!;

              return ExpansionTile(
                title: Text(
                  courseName,
                  style: TextStyle(fontSize: 18, color: darkBlue),
                ),
                children:
                    assignments.map((assignment) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        title: Text(
                          assignment.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Due Date: ${DateFormat.yMMMd().format(assignment.dueDate)},',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              'Duration: ${assignment.duration} hours',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white38,
                              ),
                            ),
                            Text(
                              'Description: ${assignment.description}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white38,
                              ),
                            ),
                            CountdownTimer(dueDate: assignment.dueDate),
                          ],
                        ),
                      );
                    }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
