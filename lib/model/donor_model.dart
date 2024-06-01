import 'dart:convert';

class Donation {
  String? id;
  String? orgName;
  String? donor;
  final bool checkFood;
  final bool checkClothes;
  final bool checkCash;
  final bool checkNecessities;
  final bool checkLogistics;
  final String date;
  final String? address;
  final String? contactNo;
  final String weight;
  final String status;
  final String organizationId;

  Donation({
    required this.orgName,
    required this.checkFood,
    required this.checkClothes,
    required this.checkCash,
    required this.checkNecessities,
    required this.checkLogistics,
    required this.date,
    this.address,
    this.contactNo,
    required this.weight,
    required this.status,
    required this.organizationId,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      orgName: json['Org Name'],
      checkFood: json['Food'],
      checkClothes: json['Clothes'],
      checkCash: json['Cash'],
      checkNecessities: json['Necessities'],
      checkLogistics: json['Mode of Delivery'],
      date: json['Date'],
      address: json['Address'],
      contactNo: json['Contact Number'],
      weight: json['Weight'],
      status: json['Status'],
      organizationId: json['OrganizationId'],
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donation donation) {
    return {
      'Org Name': donation.orgName,
      'Food': donation.checkFood,
      'Clothes': donation.checkClothes,
      'Cash': donation.checkCash,
      'Necessities': donation.checkNecessities,
      'For Delivery?': donation.checkLogistics,
      'Date': donation.date,
      'Address': donation.address,
      'Contact Number': donation.contactNo,
      'Weight': donation.weight,
      'Status': donation.status,
      'OrganizationId': donation.organizationId,
    };
  }
}
