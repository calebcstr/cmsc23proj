
import 'dart:convert';

class Donation {
  //All the variables that are needed to be shown in the summary are placed here
  String? id;
  String? orgName;
  String? donor;
  final bool checkFood;
  final bool checkClothes;
  final bool checkCash;
  final bool checkNecessities;
  //final String? others;
  final bool checkLogistics;
  final String date;
  final String? address;
  final String? contactNo;
  final String weight;


        Donation({required this.orgName,
                  required this.checkFood,
                  required this.checkClothes, 
                  required this.checkCash,
                  required this.checkNecessities,
                  required this.checkLogistics,
                  required this.date, 
                  this.address,
                  this.contactNo,
                  required this.weight});

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
      'Necessities' : donation.checkNecessities,
      'For Delivery?' : donation.checkLogistics,
      'Date' : donation.date,
      'Address' : donation.address,
      'Contact Number' : donation.contactNo,
      'Weight' : donation.weight
    };
  }
}
