import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';
class LoginController extends GetxController {
  static LoginController get instance => Get.find();


  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  /// TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();

  /// TextField Validation

  //Call this Function from Design & it will do the rest
  Future<void> login(String email,String password) async {
    String? error = await AuthenticationRepository.instance.signInWithEmailAndPassword(email, password)as String?;
    if(error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString(),));
    }

  }
  Future<void> googleSignIn() async{
    try{
      isGoogleLoading.value = true;
      await AuthenticationRepository.instance.signInWithGoogle();
      isGoogleLoading.value = false;
    }
    catch(e){
      isGoogleLoading.value = false;
      Get.snackbar('Error', 'SignIn Revoked');
    }

  }


}