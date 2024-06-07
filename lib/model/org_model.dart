import 'dart:convert';

class Organization {
  final String organizationId;
      final String organizationName;
      final String email;
      final String address;
      final String contact;
      final bool isOpenForDonations;

  Organization({
    required this.organizationId,
    required this.organizationName,
    required this.email,
    required this.address,
    required this.contact,
    this.isOpenForDonations = true, // Initialize to true
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      organizationId: json['organizationId'],
      organizationName: json['Organization Name'],
      email: json['Email'],
      address: json['Address'],
      contact: json['Contact'],
      isOpenForDonations: json['isOpenForDonations'] ?? true, // Handle missing field
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'Organization Name': organizationName,
      'Email': email,
      'Address': address,
      'Contact': contact,
      'isOpenForDonations': isOpenForDonations, // Add to JSON
    };
  }
}
