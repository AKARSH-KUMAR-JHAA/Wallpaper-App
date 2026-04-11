import 'package:get/get.dart';

class BottomNavController extends GetxController {
  static BottomNavController get instance => Get.find();
  
  final currentIndex = 1.obs; // Defaults to Home (Center)
  
  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
