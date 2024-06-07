import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUserInfoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
  try {
    
    final docRef = await db.collection("User").add(user);
      await db.collection("User").doc(docRef.id).update({'id': docRef.id});
    
    return "Successfully added User!";
  } on FirebaseException catch (e) {
    return "Failed with error '${e.code}: ${e.message}";
  }
}

Stream<QuerySnapshot> getAllUser() {
  return db.collection("User").snapshots();
}

  Future<String> deleteUser(String? id) async {
    try {
      await db.collection("User").doc(id).delete();

      return "Successfully deleted User!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
}

}