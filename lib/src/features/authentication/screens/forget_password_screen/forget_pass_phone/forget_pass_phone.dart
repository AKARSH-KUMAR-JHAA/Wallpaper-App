import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/screens/forget_password_screen/forget_header_widget.dart';
import 'package:luminawall/src/features/authentication/controller/forget_password_controller.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/constants/image_strings.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class ForgetPassPhone extends StatelessWidget {
  const ForgetPassPhone({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ForgetHeaderWidget(
                img: forgetPassPhoneImage,
                title: forgetPassTitle,
                subtitle: forgetPassPhoneSubtitle,
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: controller.phone,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: Icon(Icons.phone_android_outlined, color: kJungleGreen),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.sendResetOTP(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kJungleGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    shadowColor: kJungleGreen.withValues(alpha: 0.3),
                  ),
                  child: controller.isLoading.value 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text(
                        resetViaPhone,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                )),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  backToLogin,
                  style: TextStyle(
                    color: kJungleGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
