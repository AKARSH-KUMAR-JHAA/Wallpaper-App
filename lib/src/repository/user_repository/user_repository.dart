import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:luminawall/src/features/authentication/models/user_model.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user, String uid) async {
    await _db
        .collection("Users")
        .doc(uid)
        .set(user.toJson(), SetOptions(merge: true))
        .whenComplete(() {
      Fluttertoast.showToast(
        msg: "Account created successfully!",
        backgroundColor: kJungleEmerald,
        textColor: Colors.white,
      );
    }).catchError((error, stackTrace) {
      Fluttertoast.showToast(
        msg: "Something went wrong. Please try again.",
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        textColor: Colors.white,
      );
    });
  }

  Future<void> updateUserDetails(Map<String, dynamic> data, String uid) async {
    await _db
        .collection("Users")
        .doc(uid)
        .set(data, SetOptions(merge: true))
        .then((_) {
      Fluttertoast.showToast(
        msg: "Profile updated successfully!",
        backgroundColor: kJungleEmerald,
        textColor: Colors.white,
      );
    }).catchError((error) {
      debugPrint("Profile Update Error: $error");
      if (Get.context != null) {
        Fluttertoast.showToast(
          msg: "Failed to update profile",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      }
    });
  }

  Future<void> updateSingleField(String field, dynamic value, String uid) async {
    await _db
        .collection("Users")
        .doc(uid)
        .update({field: value})
        .catchError((error) => debugPrint("Error updating $field: $error"));
  }

  Future<void> deleteUser(String uid) async {
    await _db
        .collection("Users")
        .doc(uid)
        .delete()
        .catchError((error) => debugPrint("Error deleting user: $error"));
  }
}