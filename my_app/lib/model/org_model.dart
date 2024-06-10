import 'dart:convert';

class Organization {
  final String organizationId;
      final String organizationName;
      final String description;
      final String email;
      final String address;
      final String contact;
      final bool isOpenForDonations;

  Organization({
    required this.organizationId,
    required this.organizationName,
    required this.description,
    required this.email,
    required this.address,
    required this.contact,
    this.isOpenForDonations = true, // Initialize to true
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      organizationId: json['organizationId'],
      organizationName: json['organizationName'],
      description: json['description'],
      email: json['email'],
      address: json['address'],
      contact: json['contact'],
      isOpenForDonations: json['isOpen'] ?? true, // Handle missing field
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'organization Name': organizationName,
      'description': description,
      'email': email,
      'address': address,
      'contactNo': contact,
      'isOpen': isOpenForDonations, // Add to JSON
    };
  }
}
