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

  //get all assignments in a course and return as a stream List of Assignment
  Stream<List<Assignment>> getAssignments(String courseId) {
    try {
      final CollectionReference assignmentCollection = courseCollection
          .doc(courseId)
          .collection('assignments');
      return assignmentCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map(
              (doc) => Assignment.fromJson(doc.data() as Map<String, dynamic>),
            )
            .toList();
      });
    } catch (error) {
      print(error);
      return Stream.empty();
    }
  }

  //get all assignments with the course name
  Future<Map<String, List<Assignment>>> getAssignmentsWithCourseName() async {
    try {
      final QuerySnapshot snapshot = await courseCollection.get();
      final Map assignmentsMap = <String, List<Assignment>>{};
      for (final doc in snapshot.docs) {
        //current course id
        final String courseId = doc.id;
        //all the assignments inside the course
        final List<Assignment> assignments =
            await getAssignments(
              courseId,
            ).first; //get the first value of the stream

        //create a new key value pair with the course name and the list of assignments
        assignmentsMap[doc['name']] = assignments;
      }

      return assignmentsMap as Map<String, List<Assignment>>;
    } catch (error) {
      print(error);
      return {};
    }
  }
}
