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



  Future<void> completeDonationStatus(String id, String status, String imageURL)  {
    return firebaseService.completeDonationStatus(id,status,imageURL);
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
  String _contact = '';
  List<Map<String, dynamic>> _addresses = [];

  String get name => _name;
  String get email => _email;
  String get contact => _contact;
  List<Map<String, dynamic>> get addresses => _addresses;

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
      _contact = data['contactNo'] ?? '';
      _addresses = List<Map<String, dynamic>>.from(data['addresses'] ?? []);
      print("Fetched details: $_name, $_email, $_addresses, $_contact");
      notifyListeners();
    }
  } catch (e) {
    print("Error fetching donor details: $e");
  }
}

  Future<void> addAddress(String email, String type, String newAddress) async {
    try {
      QuerySnapshot snapshot = await db.collection('donors')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        print("No donor document found for email: $email");
        return;
      }

      DocumentReference donorRef = snapshot.docs.first.reference;

      print("Adding address: $newAddress of type: $type for user: $email");

      await donorRef.update({
        'addresses': FieldValue.arrayUnion([
          {
            'type': type,
            'address': newAddress,
          }
        ])
      });

      _addresses.add({
        'type': type,
        'address': newAddress,
      });
      notifyListeners();

      print("Address added successfully");

    } catch (e) {
      print("Error adding address: $e");
    }
  }

} 
