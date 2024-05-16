import 'package:flutter/material.dart';
import '../model/donor_model.dart';

class DonationList with ChangeNotifier {
  final List<Donation> _donationlist = [];
  Donation? _donation;

  List<Donation> get cart => _donationlist;

  changeSelectedSlambook(Donation donos) {
    _donation = donos;
  }

  void addDonation(Donation donation) {
    _donationlist.add(donation);
    notifyListeners();
  }

  void removeDonation() {
    _donationlist.remove(_donation);
    notifyListeners();
  }
}
