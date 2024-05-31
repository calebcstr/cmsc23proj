import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/donation_drive_model.dart';

class FirebaseDonationDriveAPI {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addDonationDrive(DonationDrive drive) async {
    await db.collection("donation_drives").doc(drive.donationDriveId).set({
      'donationDriveId': drive.donationDriveId,
      'name': drive.name,
      'description': drive.description,
      'organizationId': drive.organizationId,
    });
  }

  Stream<List<DonationDrive>> getAllDonationDrives() {
    return db.collection('donation_drives').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return DonationDrive(
          donationDriveId: data['donationDriveId'],
          name: data['name'],
          description: data['description'],
          organizationId: data['organizationId'],
        );
      }).toList();
    });
  }

  Future<void> deleteDonationDrive(String id) async {
    await db.collection("donation_drives").doc(id).delete();
  }

  Future<void> editDonationDrive(String id, DonationDrive updatedDrive) async {
    await db.collection("donation_drives").doc(id).update({
      'donationDriveId': updatedDrive.donationDriveId,
      'name': updatedDrive.name,
      'description': updatedDrive.description,
      'organizationId': updatedDrive.organizationId,
    });
  }
}
