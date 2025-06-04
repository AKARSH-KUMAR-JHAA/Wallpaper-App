import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:login/src/features/authentication/screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';

class OtpController extends GetxController{
  static OtpController get instance =>Get.find();
  void verifyotp(String otp)async{
    var isVerified =await AuthenticationRepository.instance.verifyotp(otp);
     isVerified? Get.offAll(SideNavBar())  : Get.back();
  }
}