import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_donor_api.dart';
import '../model/donor_model.dart';

class DonationList with ChangeNotifier {
  late FirebaseDonationAPI firebaseService;
  late Stream<QuerySnapshot> _donationStream;

DonationList() {
  firebaseService = FirebaseDonationAPI();
  fetchTodos();
}

Stream<QuerySnapshot> get getDonos => _donationStream;

  fetchTodos() {
  _donationStream = firebaseService.getAllDonation();
  notifyListeners();
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
}
