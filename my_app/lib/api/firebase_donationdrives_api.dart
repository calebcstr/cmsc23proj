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

 Future<void> editDonationDrive(String donationDriveId, String name, String description) async {
    try {
      await db.collection('donation_drives').doc(donationDriveId).update({
        'name': name,
        'description': description,
      });
    } catch (e) {
      print('Error editing donation drive: $e');
      throw e;
    }
  }

   Stream<QuerySnapshot> getDrivesbyOrg(String organizationId)
  {
    return db.collection("donation_drives").where('OrganizationId', isEqualTo: organizationId).snapshots();
  }

  Stream<List<DonationDrive>> getDrivesByOrgId(String orgId) {
    return db
        .collection('donation_drives')
        .where('organizationId', isEqualTo: orgId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return DonationDrive.fromJson(data);
      }).toList();
    });
  }

}
