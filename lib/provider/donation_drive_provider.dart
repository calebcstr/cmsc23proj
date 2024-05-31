import 'package:flutter/material.dart';
import '../api/firebase_donationdrives_api.dart';
import '../model/donation_drive_model.dart';

class DonationDriveProvider with ChangeNotifier {
  final FirebaseDonationDriveAPI firebaseService = FirebaseDonationDriveAPI();
  late Stream<List<DonationDrive>> _drivesStream;

  DonationDriveProvider() {
    _drivesStream = firebaseService.getAllDonationDrives();
  }

  Stream<List<DonationDrive>> get drivesStream => _drivesStream;

  Future<void> addDonationDrive(DonationDrive drive) async {
    await firebaseService.addDonationDrive(drive);
    notifyListeners();
  }

  Future<void> deleteDonationDrive(String id) async {
    await firebaseService.deleteDonationDrive(id);
    notifyListeners();
  }

  Future<void> editDonationDrive(String id, DonationDrive updatedDrive) async {
    await firebaseService.editDonationDrive(id, updatedDrive);
    notifyListeners();
  }
}
