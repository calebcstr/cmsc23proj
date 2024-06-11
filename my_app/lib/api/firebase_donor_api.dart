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

Stream<DocumentSnapshot> getDonation(String donationId) {
  return db.collection("Donation").doc(donationId).snapshots();
}

   Stream<QuerySnapshot> getDonationsbyOrg(String organizationId)
  {
    return db.collection("Donation").where('OrganizationId', isEqualTo: organizationId).snapshots();
  }

     Stream<QuerySnapshot> getDonationsbyEmail(String donorEmail)
  {
    return db.collection("Donation").where('Email', isEqualTo: donorEmail).snapshots();
  }


  Future<void> updateDonationStatus(String donationId, String newStatus) async {
    try {
      await db.collection('Donation').doc(donationId).update({
        'Status': newStatus,
      });
      print('Donation status updated successfully.');
    } catch (e) {
      print('Error updating donation status: $e');
      throw Exception('Failed to update donation status.');
    }
  }

  Future<void> completeDonationStatus(String donationId, String newStatus, String? imageURL) async {
    try {
      await db.collection('Donation').doc(donationId).update({
        'Status': newStatus,
        if (imageURL != null) 'photoOfproof': imageURL,
      });
      print('Donation status updated successfully.');
    } catch (e) {
      print('Error updating donation status: $e');
      throw Exception('Failed to update donation status.');
    }
  }

   Future<String> getStatus(String donationId) async {
    try {
      DocumentSnapshot donationDoc = await db.collection('Donation').doc(donationId).get();
      if (donationDoc.exists) {
        return donationDoc['Status'];
      } else {
        throw Exception('Document with ID $donationId not found.');
      }
    } catch (e) {
      print('Error getting donation status: $e');
      rethrow;
    }
  }

}