import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner_app/models/course_model.dart';

class CourseService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection('courses');

  Future<void> createCourse(Course course) async {
    try {
      final Map<String, dynamic> data = course.toJson();

      // Add the course to the collection
      await courseCollection.add(data);
    } catch (error) {
      print('Error creating course: $error');
    }
  }
}
