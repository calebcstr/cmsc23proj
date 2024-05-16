import 'package:cmsc23proj/model/org_model.dart';
import 'package:flutter/material.dart';
import '../model/org_model.dart';

class OrganizationList with ChangeNotifier {
  final List<Organization> _organizationList = [];

  List<Organization> get orgList => _organizationList;

  void addOrganization(Organization org) {
    _organizationList.add(org);
    notifyListeners();
  }

  void removeDonation(String name) {
    for (int i = 0; i < _organizationList.length; i++) {
      if (_organizationList[i].name == name) {
        _organizationList.remove(_organizationList[i]);
        break;
      }
    }
    notifyListeners();
  }
}
