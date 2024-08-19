import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageFirebaseService {
  Future<String> uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;
    final ref = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final file = File(imagePath);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putFile(file, metadata);

      // uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      //   print('Task state: ${snapshot.state}');
      //   print(
      //       'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      // }, onError: (e) {
      //   print('Upload error: $e');
      // });

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
