import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_auth_api.dart';

class FirebaseAuthApi {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> fetchUser() {
    return _auth.authStateChanges();
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future<String?> signUpDonor(String name, String email, String password, String address, String contactNo) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('donors').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'address': address,
        'contactNo': contactNo,
      });

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String?> signUpOrganization(
  String organizationName,
  String email,
  String password,
  String address,
  String contactNo,
  String organizationId,
  String? proofOfLegitimacy,
  bool isOpenForDonations,
) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    await _firestore.collection('organizations').doc(uid).set({
      'organizationId': organizationId,
      'organizationName': organizationName,
      'email': email,
      'address': address,
      'contactNo': contactNo,
      'proofOfLegitimacy': proofOfLegitimacy,
      'isOpenForDonations': isOpenForDonations,
      'isApproved': false,
    });

    return null;
  } on FirebaseAuthException catch (e) {
    return e.code;
  } catch (e) {
    return 'Error: $e';
  }
}

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      String uid = credentials.user!.uid;

      DocumentSnapshot donorDoc = await _firestore.collection('donors').doc(uid).get();
      if (donorDoc.exists) {
        return "donor";
      }

      DocumentSnapshot orgDoc = await _firestore.collection('organizations').doc(uid).get();
      if (orgDoc.exists) {
        bool isApproved = orgDoc.get('isApproved');
        if (isApproved) {
          return "organization";
        } else {
          return "not-approved";
        }
      }

      // Add admin check if needed
      DocumentSnapshot adminDoc = await _firestore.collection('admins').doc(uid).get();
      if (adminDoc.exists) {
        return "admin";
      }

      return "user-not-found";
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot> fetchUserDetails(String uid, String userType) async {
    return _firestore.collection(userType).doc(uid).get();
  }
}
