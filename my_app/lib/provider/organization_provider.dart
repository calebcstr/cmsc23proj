import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_organization_api.dart';
import '../model/org_model.dart';

class OrganizationList with ChangeNotifier {
  final FirebaseOrganizationAPI firebaseService = FirebaseOrganizationAPI();
  late Stream<List<Organization>> _organizationList;

  OrganizationList() {
    _organizationList = firebaseService.getAllOrganizations();
  }

  Stream<List<Organization>> get orgList => _organizationList;


  Future<void> addOrganization(Organization org) async {
    await firebaseService.addOrganization(org);
    notifyListeners();
  }

  Future<void> deleteOrganization(String id) async {
    await firebaseService.deleteOrganization(id);
    notifyListeners();
  }

  Stream<List<Organization>> getAllOrganizations() {
    return firebaseService.getAllOrganizations();
  }

  Stream<List<Organization>> getAllOpenOrganizations() {
    return firebaseService.getAllOpenOrganizations();
  }
}

class OrganizationIdProvider with ChangeNotifier {
  String _organizationId = '';
  final FirebaseOrganizationAPI _firebaseService = FirebaseOrganizationAPI();

  String get organizationId => _organizationId;

  Future<void> fetchAndSetOrganizationId(String orgDocumentId) async {
    try {
      String id = await _firebaseService.getOrganizationId(orgDocumentId);
      _organizationId = id;
      notifyListeners();
    } catch (e) {
      // Handle errors here
      print('Error fetching organizationId: $e');
    }
  }

  void setOrganizationId(String id) {
    _organizationId = id;
    notifyListeners();
  }
}

class OrganizationProvider extends ChangeNotifier {
  String _organizationName = '';
  String _email = '';
  String _address = '';
  String _contact = '';
  bool _isOpenForDonations = false;
  String _organizationId = '';

  String get organizationName => _organizationName;
  String get email => _email;
  String get address => _address;
  String get contact => _contact;
  bool get isOpenForDonations => _isOpenForDonations;

  Future<void> fetchOrganizationDetails(String field, String organizationId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseOrganizationAPI.getOrganization(field,organizationId);
      if (doc.exists) {
        final data = doc.data()!;
        _organizationId = organizationId;
        _organizationName = data['organizationName'] ?? '';
        _email = data['email'] ?? '';
        _address = data['address'] ?? '';
        _contact = data['contactNo'] ?? '';
        _isOpenForDonations = data['isOpen'] ?? false;
        notifyListeners();
      } 
    } catch (e) {
      print('Error fetching organization details: $e');
    }
  }

  Future<void> updateIsOpenForDonations(bool status) async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('organizations')
        .where('organizationId', isEqualTo: _organizationId)
        .get();

    for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.update({
        'isOpen': status,
      });
    }

    _isOpenForDonations = status;
    notifyListeners();
  } catch (e) {
    print('Error updating isOpenForDonations: $e');
  }
}

}