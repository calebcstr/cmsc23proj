import 'package:cmsc23proj/model/org_model.dart';
import 'package:flutter/material.dart';
import '../api/firebase_organization_api.dart';

class OrganizationList with ChangeNotifier {
  final List<Organization> _organizationList = [];

  List<Organization> get orgList => _organizationList;

  void addOrganization(Organization org) {
    _organizationList.add(org);
    notifyListeners();
  }

  void removeDonation(String name) {
    for (int i = 0; i < _organizationList.length; i++) {
      if (_organizationList[i].organizationName == name) {
        _organizationList.remove(_organizationList[i]);
        break;
      }
    }
    notifyListeners();
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