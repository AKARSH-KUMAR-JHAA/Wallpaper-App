import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants/colors_strings.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../../../repository/user_repository/user_repository.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.find<AuthenticationRepository>();
  final userModel = Rxn<UserModel>();
  final pickedImage = Rxn<File>();
  final isLoading = false.obs;

  StreamSubscription? _userSubscription;

  @override
  void onInit() {
    super.onInit();
    if (_authRepo.firebaseUser.value != null) {
      _subscribeToUserData(_authRepo.firebaseUser.value!.uid);
    }

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
        .collection("Users")
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        userModel.value = UserModel.fromSnapshot(snapshot);
      }
    });
  }

  // Upload Profile Picture
  Future<void> uploadProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image == null) return;

      // START CROP LOGIC
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Force square
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: kJungleDeepGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            activeControlsWidgetColor: kJungleEmerald,
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
          ),
        ],
      );

      if (croppedFile == null) return;

      isLoading.value = true;
      pickedImage.value = File(croppedFile.path);

      final uid = _authRepo.firebaseUser.value?.uid;
      if (uid == null) return;

      // Upload to Firebase Storage
      final ref = FirebaseStorage.instance.ref().child('users/ProfilePictures/$uid');
      debugPrint("Uploading NEW image from: ${pickedImage.value!.path}");
      
      await ref.putFile(pickedImage.value!);
      final downloadUrl = await ref.getDownloadURL();
      
      // Add a timestamp to bypass local image caching
      final finalUrl = "$downloadUrl&t=${DateTime.now().millisecondsSinceEpoch}";
      debugPrint("New Image URL: $finalUrl");

      // Update Firestore: We ensure we don't overwrite Name/Email if they exist,
      // but if the document is being CREATED now (e.g. first time user), 
      // we should include the basic info from Auth.
      final currentUser = _authRepo.firebaseUser.value;
      final Map<String, dynamic> updateData = {
        "ProfilePicture": finalUrl,
      };

      // If Firestore data is currently missing, let's populate it from Auth
      if (userModel.value == null || userModel.value!.fullName.isEmpty) {
        updateData["FullName"] = currentUser?.displayName ?? "";
      }
      if (userModel.value == null || userModel.value!.email.isEmpty) {
        updateData["Email"] = currentUser?.email ?? "";
      }

      await UserRepository.instance.updateUserDetails(updateData, uid);

      // Manually update the local model immediately for snappier UI
      if (userModel.value != null) {
        userModel.value = UserModel(
          fullName: userModel.value!.fullName.isEmpty ? (currentUser?.displayName ?? "") : userModel.value!.fullName,
          email: userModel.value!.email.isEmpty ? (currentUser?.email ?? "") : userModel.value!.email,
          phoneNo: userModel.value!.phoneNo,
          password: userModel.value!.password,
          profilePicture: finalUrl,
          id: userModel.value!.id,
        );
      }
      
      // Clear picked image so it switched back to network url
      pickedImage.value = null;
      debugPrint("Profile Picture Update Complete!");

      Fluttertoast.showToast(
        msg: "Profile picture updated!",
        backgroundColor: kJungleEmerald,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("Photo Upload Error: $e");
      Fluttertoast.showToast(
        msg: "Failed to upload image",
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update User Data
  Future<void> updateRecord(UserModel user) async {
    try {
      isLoading.value = true;
      final uid = _authRepo.firebaseUser.value?.uid;
      if (uid != null) {
        await UserRepository.instance.updateUserDetails(user.toJson(), uid);
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
        if (Get.isBottomSheetOpen == true || Get.isDialogOpen == true) {
          if (Get.context != null) Navigator.pop(Get.context!);
        }
        
        await UserRepository.instance.deleteUser(uid);
        await user?.delete();
        
        Fluttertoast.showToast(
          msg: "Your account has been permanently removed.",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
            
        await _authRepo.logout();
      }
    } catch (e) {
      debugPrint("Account Deletion Error: $e");
      Fluttertoast.showToast(
        msg: "For security, please re-login before deleting your account.",
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
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
