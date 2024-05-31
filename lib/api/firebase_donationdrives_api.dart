import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDonationDriveAPI {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addDonationDrive(Map<String, dynamic> drive) async {
    await db.collection("donation_drives").add(drive);
  }

  Stream<QuerySnapshot> getAllDonationDrives() {
    return db.collection('donation_drives').snapshots();
  }

  Future<void> deleteDonationDrive(String id) async {
    await db.collection("donation_drives").doc(id).delete();
  }

  Future<void> editDonationDrive(String id, Map<String, dynamic> updatedDrive) async {
    await db.collection("donation_drives").doc(id).update(updatedDrive);
  }
}
