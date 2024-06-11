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
  String? _organizationName; // Added organizationName field

  UserAuthProvider({required this.authService}) {
    _userStream = authService.fetchUser();
    _userStream.listen((user) async {
      _user = user;
      if (user != null) {
        await _fetchUserRole(user.uid);
        if (_userRole == "organization" && _organizationId != null) {
          await _fetchOrganizationName(_organizationId!); // Fetch organization name
        }
      } else {
        _userRole = null;
        _organizationId = null;
        _organizationName = null;
      }
      notifyListeners();
    });
  }

    Future<Map<String, dynamic>?> fetchDonorDetails(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('donor')
          .where('email', isEqualTo: email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error fetching donor details: $e");
    }
    return null;
  }
  Stream<User?> get userStream => _userStream;
  User? get user => _user;
  String? get userRole => _userRole;
  String? get organizationId => _organizationId;
  String? get organizationName => _organizationName; // Getter for organizationName

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

  Future<void> _fetchOrganizationName(String organizationId) async {
    try {
      DocumentSnapshot orgDoc = await _firestore.collection('organizations').doc(organizationId).get();
      if (orgDoc.exists) {
        _organizationName = orgDoc.get('organizationName') as String?;
      }
    } catch (e) {
      _organizationName = null;
      print('Error fetching organization name: $e');
    }
  }

  Future<String?> getOrganizationName(String? organizationId) async {
  try {
    DocumentSnapshot orgDoc = await _firestore.collection('organizations').doc(organizationId).get();
    if (orgDoc.exists) {
      return orgDoc.get('organizationName') as String?;
    }
  } catch (e) {
    print('Error fetching organization name: $e');
  }
  return null;
}

  Future<void> signOut() async {
    await authService.signOut();
    _user = null;
    _userRole = null;
    _organizationId = null;
    _organizationName = null;
    notifyListeners();
  }

  String? getCurrentOrganizationId() {
    return _organizationId;
  }
}
