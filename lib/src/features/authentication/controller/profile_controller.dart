import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.find<AuthenticationRepository>();

  final userModel = Rxn<UserModel>();

  StreamSubscription? _userSubscription;

  @override
  void onInit() {
    super.onInit();
    
    // 1. Check if user is already logged in and fetch data immediately
    if (_authRepo.firebaseUser.value != null) {
      _subscribeToUserData(_authRepo.firebaseUser.value!.uid);
    }

    // 2. Listen to future changes in firebaseUser
    ever(_authRepo.firebaseUser, (User? user) {
      _userSubscription?.cancel();
      if (user != null) {
        _subscribeToUserData(user.uid);
      } else {
        userModel.value = null;
      }
    });
  }

  void _subscribeToUserData(String uid) {
    _userSubscription = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        userModel.value = UserModel(
          fullName: snapshot.data()?['FullName'] ?? '',
          email: snapshot.data()?['Email'] ?? '',
          phoneNo: snapshot.data()?['PhoneNo'] ?? '',
          password: '', // Hidden for security
        );
      }
    });
  }

  // Update User Data
  final isLoading = false.obs;
  
  Future<void> updateRecord(UserModel user) async {
    try {
      isLoading.value = true;
      final uid = _authRepo.firebaseUser.value?.uid;
      if (uid != null) {
        await UserRepository.instance.updateUserDetails(user, uid);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;
      final user = _authRepo.firebaseUser.value;
      final uid = user?.uid;
      
      if (uid != null) {
        // Close any open dialogs/bottomsheets first using native Navigator
        if (Get.isBottomSheetOpen == true || Get.isDialogOpen == true) Navigator.pop(Get.context!);
        
        await UserRepository.instance.deleteUser(uid);
        await user?.delete();
        
        if (Get.context != null) {
          ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: const Text("Your account has been permanently removed."),
              backgroundColor: Colors.red.withValues(alpha: 0.8),
            ),
          );
        }
            
        await _authRepo.logout();
      }
    } catch (e) {
      debugPrint("Account Deletion Error: $e");
      if (Get.context != null) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: const Text("For security, please re-login before deleting your account."),
            backgroundColor: Colors.orange.withValues(alpha: 0.9),
          ),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }
}
