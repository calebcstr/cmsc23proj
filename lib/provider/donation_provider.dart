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

    Stream<QuerySnapshot> getDonationsbyEmail(String? donorEmail) {
    return firebaseService.getDonationsbyEmail(donorEmail!);
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

  Future<String> cancelStatus(String donationId) async {
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

class DonorProvider with ChangeNotifier {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  
  String _name = '';
  String _email = '';
  String _address = '';
  String _contact = '';

  String get name => _name;
  String get email => _email;
  String get address => _address;
  String get contact => _contact;

Future<void> fetchDonorDetails(String email) async {
  try {
    print("Fetching donor details for: $email");
    QuerySnapshot snapshot = await db.collection('donors')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      _name = data['name'] ?? '';
      _email = data['email'] ?? '';
      _address = data['address'] ?? '';
      _contact = data['contactNo'] ?? '';
      print("Fetched details: $_name, $_email, $_address, $_contact");
      notifyListeners();
    }
  } catch (e) {
    print("Error fetching donor details: $e");
  }
}

} 
