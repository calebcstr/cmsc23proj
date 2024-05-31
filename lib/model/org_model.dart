import 'dart:convert';

class Organization {
  final String id;
  final String organizationName;
  final String email;
  final String username;
  final String name;
  final String address;
  final String contact;

  Organization({
    required this.id,
    required this.organizationName,
    required this.email,
    required this.username,
    required this.name,
    required this.address,
    required this.contact,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'],
      organizationName: json['Organization Name'],
      email: json['Email'],
      username: json['Username'],
      name: json['Name'],
      address: json['Address'],
      contact: json['Contact'],
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Organization Name': organizationName,
      'Email': email,
      'Username': username,
      'Name': name,
      'Address': address,
      'Contact': contact,
    };
  }
}
