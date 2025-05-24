import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_planner_app/models/note_model.dart';
import 'package:study_planner_app/services/cloudstorage/store_images.dart';

class NoteService {
  final CollectionReference courseCollection = FirebaseFirestore.instance
      .collection('courses');

  Future<void> createNote(String courseId, Note note) async {
    try {
      String? imageUrl;
      if (note.imageData != null) {
        imageUrl = await StorageService().uploadImage(
          noteImage: note.imageData!,
          courseId: courseId,
        );
      }

      // Create a new note object
      final Note newNote = Note(
        id: "",
        title: note.title,
        description: note.description,
        section: note.section,
        references: note.references,
        imageUrl: imageUrl,
      );

      // Save the note to Firestore
      final DocumentReference docref = await courseCollection
          .doc(courseId)
          .collection("notes")
          .add(newNote.toJson());

      await docref.update({'id': docref.id});
      print("Note Uploaded");
    } catch (error) {
      print(error);
    }
  }
}
