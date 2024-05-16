import 'package:flutter/material.dart';
import '../model/donor_model.dart';

class DonationList with ChangeNotifier {
  final List<Donation> _donationlist = [];

  List<Donation> get cart => _donationlist;

  void addDonation(Donation donation) {
    _donationlist.add(donation);
    notifyListeners();
  }

  void removeDonation(String date) {
    for (int i = 0; i < _donationlist.length; i++) {
      if (_donationlist[i].date == date) {
        _donationlist.remove(_donationlist[i]);
        break;
      }
    }
    notifyListeners();
  }
}
