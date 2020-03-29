import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Firestore _db = Firestore.instance;

  Future<void> uploadRecipeImage(String feedId) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference reference = _storage.ref().child('feeds').child(feedId).child(feedId);
    StorageUploadTask uploadTask = reference.putFile(image);

    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        StorageTaskSnapshot storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          _db.collection('feeds').document(feedId).updateData(({
            'recipeImage': downloadUrl,
          }));
        });
      } else {}
    }, onError: (err) {
      print("Failed to upload image $err");
    });
  }


  Future<void> uploadImage(String userId) async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference reference = _storage.ref().child('user_images').child(userId);
    StorageUploadTask uploadTask = reference.putFile(image);

    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        StorageTaskSnapshot storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          _db.collection('users').document(userId).updateData(({
                'photo': downloadUrl,
              }));
        });
      } else {}
    }, onError: (err) {
      print("Failed to upload image $err");
    });
  }

  Future<void> deleteImage(String userId) async {
    StorageReference reference = _storage.ref().child('user_images').child(userId);

    reference
        .getDownloadURL()
        .then((value) => deleteUserImageReference(userId, reference))
        .catchError((onError) => deleteUserImage(userId));
  }

  Future<void> deleteUserImageReference(String userId, StorageReference reference) async {
    await reference.delete();
    await deleteUserImage(userId);
  }

  Future<void> deleteUserImage(String userId) async {
    await _db.collection('users').document(userId).updateData(
          ({
            'photo': '',
          }),
        );
  }
}
