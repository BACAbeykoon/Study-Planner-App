import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  //Firebase storage instance
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({
    required File noteImage,
    required String courseId,
  }) async {
    try {
      Reference ref = _storage
          .ref()
          .child("note-images")
          .child("$courseId/${DateTime.now()}");

      UploadTask task = ref.putFile(
        noteImage,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return "";
    }
  }
}
