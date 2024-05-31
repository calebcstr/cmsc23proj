import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  final FirebaseAuthApi authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<User?> _userStream;
  User? _user;
  String? _userRole;
  String? _organizationId;

  UserAuthProvider({required this.authService}) {
    _userStream = authService.fetchUser();
    _userStream.listen((user) async {
      _user = user;
      if (user != null) {
        await _fetchUserRole(user.uid);
      } else {
        _userRole = null;
        _organizationId = null;
      }
      notifyListeners();
    });
  }

  Stream<User?> get userStream => _userStream;
  User? get user => _user;
  String? get userRole => _userRole;
  String? get organizationId => _organizationId;

  Future<void> _fetchUserRole(String uid) async {
    try {
      DocumentSnapshot donorDoc = await _firestore.collection('donors').doc(uid).get();
      if (donorDoc.exists) {
        _userRole = "donor";
        return;
      }

      DocumentSnapshot orgDoc = await _firestore.collection('organizations').doc(uid).get();
      if (orgDoc.exists) {
        bool isApproved = orgDoc.get('isApproved');
        _userRole = isApproved ? "organization" : "not-approved-organization";
        if (isApproved) {
          _organizationId = orgDoc.get('organizationId');
        }
        return;
      }

      // Add admin check if needed
      DocumentSnapshot adminDoc = await _firestore.collection('admins').doc(uid).get();
      if (adminDoc.exists) {
        _userRole = "admin";
        return;
      }

      _userRole = "user-not-found";
    } catch (e) {
      _userRole = "error";
      print('Error fetching user role: $e');
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    _user = null;
    _userRole = null;
    _organizationId = null;
    notifyListeners();
  }

  String? getCurrentOrganizationId() {
    return _organizationId;
  }
}
