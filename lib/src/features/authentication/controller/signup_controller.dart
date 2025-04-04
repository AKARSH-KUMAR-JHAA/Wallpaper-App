import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/models/user_model.dart';
import 'package:login/src/features/authentication/screens/forget_password_screen/forget_pass_otp/forget_pass_otp.dart';
import 'package:login/src/repository/user_repository/user_repository.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';


class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
  final conpassword = TextEditingController();

  final userRepo = Get.put(UserRepository());

  //Call this Function from Design & it will do the rest
  void registerUser(String email, String password) {
    String? error = AuthenticationRepository.instance.createUserWithEmailAndPassword(email, password) as String?;
    if(error != null) {
      Get.showSnackbar(GetSnackBar(message: error.toString()));
    }
  }
  Future<void> phoneAuthentication(String phoneNo) async {
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
  Future<void> creatUser(UserModel user) async {
   await userRepo.createUser(user);
    phoneAuthentication(user.phoneNo);
    Get.to(()=> ForgetPassOtp());
  }


}