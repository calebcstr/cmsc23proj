import 'dart:convert';

class User {
String? id;
String accountId;
String email;
String username;
int accountType; 
String status;
String? regNumber; //for org
String? about;  //for org

  User({
      required this.accountId,
      required this.email,
      required this.username,
      //required this.password,
      required this.accountType,
      required this.status,
      required this.regNumber
  });

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accountId: json['Account ID'],
      email: json['Email'],
      username: json['Username'],
      accountType: json['Account Type'],
      status: json['Status'],
      regNumber: json['Registration Number'],
    );
  }

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

    Map<String, dynamic> toJson(User user) {
    return {
      'Account ID': user.accountId,
      'Email': user.email,
      'Username': user.username,
      'Account Type': user.accountType,
      'Status' : user.status,
      'Registration Number' : user.regNumber,
    };
  }
}