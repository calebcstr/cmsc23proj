import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donation) async {
  try {
    
    final docRef = await db.collection("Donation").add(donation);
      await db.collection("Donation").doc(docRef.id).update({'id': docRef.id});
    
    return "Successfully added Donation Entry!";
  } on FirebaseException catch (e) {
    return "Failed with error '${e.code}: ${e.message}";
  }
}

Stream<QuerySnapshot> getAllDonation() {
  return db.collection("Donation").snapshots();
}

  Future<String> deleteDonation(String? id) async {
    try {
      await db.collection("Donation").doc(id).delete();

      return "Successfully deleted Donation Entry!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
}

}