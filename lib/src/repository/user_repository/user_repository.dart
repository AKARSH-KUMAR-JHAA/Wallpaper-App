import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user, String uid) async {
    await _db
        .collection("users")
        .doc(uid)
        .set(user.toJson())
        .whenComplete(() {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
      }
    }).catchError((error, stackTrace) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Text("Something went wrong. Please try again."),
            backgroundColor: Colors.red.withValues(alpha: 0.8),
          ),
        );
      }
    });
  }

  Future<void> updateUserDetails(UserModel user, String uid) async {
    await _db
        .collection("users")
        .doc(uid)
        .set(user.toJson(), SetOptions(merge: true))
        .then((_) {
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Text("Profile updated successfully!"),
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }).catchError((error) {
      debugPrint("Profile Update Error: $error");
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Text("Failed to update profile"),
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Future<void> deleteUser(String uid) async {
    await _db
        .collection("users")
        .doc(uid)
        .delete()
        .catchError((error) => debugPrint("Error deleting user: $error"));
  }
}