import 'dart:convert';
import 'donor_model.dart';

class DonationDrive {
  final String donationDriveId;
  final String name;
  final String description;
  final String organizationId; // New field for organizationId

  DonationDrive({
    required this.donationDriveId,
    required this.name,
    required this.description,
    required this.organizationId, // Include organizationId in the constructor
  });

}
