import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc23proj/api/firebase_userinfo_api.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class UserInfo with ChangeNotifier {
  late FirebaseUserInfoAPI firebaseService;
  late Stream<QuerySnapshot> _userStream;

UserInfo() {
  firebaseService = FirebaseUserInfoAPI();
  fetchTodos();
}

Stream<QuerySnapshot> get getUser => _userStream;

  fetchTodos() {
  _userStream = firebaseService.getAllUser();
  notifyListeners();
}

  void addDonation(User user) async {
    String message = await firebaseService.addUser(user.toJson(user));
    print(message);
    notifyListeners();
  }

  void deleteDonation(String id) async {
    String message = await firebaseService.deleteUser(id);
    print(message);
    notifyListeners();
  }
}

