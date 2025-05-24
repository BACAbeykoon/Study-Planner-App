import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner_app/models/assignment_model.dart';

class AssignmentService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection('courses');

  Future<void> createAssignment(String courseId, Assignment assignment) async {
    try {
      final Map<String, dynamic> data = assignment.toJson();
      final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection('assignments');
      DocumentReference docRef = await assignmentCollection.add(data);

      await docRef.update({'id': docRef.id});
      print("Assignment saved");
    } catch (error) {
      print(error);
    }
  }
}
