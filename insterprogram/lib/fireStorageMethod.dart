import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
class StorageMethods {
 

  // adding image to firebase storage
  Future<String> uploadVideoToStorage(Uint8List file) async {
    // creating location to our firebase storage
    final FirebaseStorage _storage = FirebaseStorage.instance;
    
    Reference ref =
        _storage.ref().child('VideoList');
        String an=const Uuid().v1();
        ref=ref.child(an);
    
    UploadTask uploadTask = ref.putData(
      file
    );

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  Future<Uint8List> convertXFileToUint8List(XFile xFile) async {
  File file = File(xFile.path);
  List<int> bytes = await file.readAsBytes();
  return Uint8List.fromList(bytes);
}
}