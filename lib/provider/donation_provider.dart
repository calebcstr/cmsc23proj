import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donor_api.dart';
import '../model/donor_model.dart';

class DonationList with ChangeNotifier {
  late FirebaseDonationAPI firebaseService;
  late Stream<QuerySnapshot> _donationStream;

  DonationList() {
    firebaseService = FirebaseDonationAPI();
  }

  Stream<QuerySnapshot> get getDonos => _donationStream;

  Stream<QuerySnapshot> getDonationsbyOrg(String organizationId) {
    return firebaseService.getDonationsbyOrg(organizationId);
  }


  Future<void> updateDonationStatus(String id, String status)  {
    return firebaseService.updateDonationStatus(id,status);
  }

  Future<String> getStatus(String donationId) async {
    try {
      return await firebaseService.getStatus(donationId);
    } catch (e) {
      print('Error getting donation status: $e');
      rethrow;
    }
  }
 
  void addDonation(Donation donation) async {
    String message = await firebaseService.addDonation(donation.toJson(donation));
    print(message);
    notifyListeners();
  }

  void deleteDonation(String id) async {
    String message = await firebaseService.deleteDonation(id);
    print(message);
    notifyListeners();
  }
 Stream<DocumentSnapshot> getDonationById(String donationId) {
    return firebaseService.getDonation(donationId);
  }

}
