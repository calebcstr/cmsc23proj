import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/org_model.dart';
import '../model/donation_drive_model.dart';

class FirebaseOrganizationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // Add organization with user uid
  Future<String> addOrganization(Organization organization) async {
    try {
      await db
          .collection("organizations")
          .doc(organization.organizationId)
          .set(organization.toJson());
      return "Successfully registered organization!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  // Get all organizations
  Stream<List<Organization>> getAllOpenOrganizations() {
    return db
        .collection('organizations')
        .where('isOpenForDonations', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Organization(
          organizationId: data['organizationId'] ?? '',
          organizationName: data['organizationName'] ?? '',
          email: data['email'] ?? '',
          address: data['address'] ?? '',
          contact: data['contactNo'] ?? '',
          isOpenForDonations: data['isOpenForDonations'] ?? false,
        );
      }).toList();
    });
  }

    Stream<List<Organization>> getAllOrganizations() {
    return db
        .collection('organizations')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Organization(
          organizationId: data['organizationId'] ?? '',
          organizationName: data['organizationName'] ?? '',
          email: data['email'] ?? '',
          address: data['address'] ?? '',
          contact: data['contactNo'] ?? '',
          isOpenForDonations: data['isOpenForDonations'] ?? false,
        );
      }).toList();
    });
  }

  // Delete organization  
  Future<String> deleteOrganization(String id) async {
    try {
      await db.collection("organizations").doc(id).delete();

      return "Successfully deleted organization!";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

   Future<String> getOrganizationId(String orgDocumentId) async {
    DocumentSnapshot doc = await db.collection('organizations').doc(orgDocumentId).get();
    if (doc.exists) {
      return doc['organizationId']; 
    } else {
      throw Exception('Organization not found');
    }
  }

static Future<DocumentSnapshot<Map<String, dynamic>>> getOrganization(String fieldName, String fieldValue) async {
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('organizations').where(fieldName, isEqualTo: fieldValue).get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first;
  } else {
    throw Exception('Organization not found');
  }
}

}


