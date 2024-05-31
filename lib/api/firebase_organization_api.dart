import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/org_model.dart';

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
  Stream<QuerySnapshot> getAllOrganizations() {
    return db.collection("organizations").snapshots();
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
}


