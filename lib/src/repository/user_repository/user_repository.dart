import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
   await _db.collection("users").add(user.toJson()).whenComplete(() =>
        Get.snackbar(
            "Success", "Your Account has been Created",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.shade200,
            colorText: Colors.green),)
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Someting Went Wrong. Please try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.shade200,
          colorText: Colors.redAccent);
      print(error.toString());
    });
  }
}