import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner_app/models/course_model.dart';

class CourseService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection('courses');

  Future<void> createCourse(Course course) async {
    try {
      final Map<String, dynamic> data = course.toJson();

      // Add the course to the collection
      final docRef = await courseCollection.add(data);

      await docRef.update({'id': docRef.id});
      print("course Saved");
    } catch (error) {
      print('Error creating course: $error');
    }
  }

  //get all courses as a stream List of Course
  Stream<List<Course>> get courses {
    return courseCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Course.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
