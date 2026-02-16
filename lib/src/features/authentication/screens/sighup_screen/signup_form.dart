import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/models/field_form_model.dart';
import 'package:luminawall/src/features/authentication/controller/signup_controller.dart';
import 'package:luminawall/src/features/authentication/models/user_model.dart';
import '../../../../common_widget/field_form_widget.dart';
import '../../../../constants/colors_strings.dart';
import 'package:intl_phone_field/intl_phone_field.dart' as intl;
import 'package:intl_phone_field/country_picker_dialog.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controllers = Get.put(SignUpController());
    final signupKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Form(
        key: signupKey,
        child: Column(
          children: [
            const SizedBox(height: 15),
            // 1. Full Name (Always visible initially)
            FormFieldWidget(
                model: Fieldformmodel(
                    field: controllers.fullName,
                    label: 'Full Name',
                    preicon: Icons.person_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Full Name is required";
                      if (value.length < 3) return "Name must be at least 3 characters";
                      return null;
                    })),

            // 2. Email Address
            Obx(() => _animatedField(
                  show: controllers.showEmail.value,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      FormFieldWidget(
                          model: Fieldformmodel(
                              field: controllers.email,
                              label: 'Email',
                              preicon: Icons.email_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Email is required";
                                if (!GetUtils.isEmail(value)) return "Enter a valid email";
                                return null;
                              })),
                    ],
                  ),
                )),

            // 3. Phone Number with Country Code
            Obx(() => _animatedField(
                  show: controllers.showPhone.value,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.fromSeed(
                            seedColor: kJungleEmerald,
                            primary: kJungleEmerald,
                            surface: Theme.of(context).brightness == Brightness.dark ? kJungleMossDark : Colors.white,
                          ),
                          dialogTheme: DialogThemeData(
                            backgroundColor: Theme.of(context).brightness == Brightness.dark ? kJungleMossDark : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: intl.IntlPhoneField(
                            controller: controllers.phoneNo,
                            cursorColor: kJungleEmerald,
                            disableLengthCheck: true,
                            dropdownIconPosition: intl.IconPosition.trailing,
                            flagsButtonMargin: const EdgeInsets.only(left: 10),
                            pickerDialogStyle: PickerDialogStyle(
                              backgroundColor: Theme.of(context).brightness == Brightness.dark ? kJungleMossDark : Colors.white,
                              countryCodeStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? kJungleCream : Colors.black87),
                              countryNameStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? kJungleCream : Colors.black87),
                              searchFieldInputDecoration: InputDecoration(
                                hintText: 'Search country',
                                hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? kJungleCream.withValues(alpha: 0.4) : Colors.grey),
                                prefixIcon: const Icon(Icons.search, color: kJungleEmerald),
                                filled: true,
                                fillColor: Theme.of(context).brightness == Brightness.dark ? kJungleCream.withValues(alpha: 0.05) : Colors.grey[100],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                              ),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).brightness == Brightness.dark 
                                  ? kJungleCream.withValues(alpha: 0.05) 
                                  : Colors.grey[100],
                              labelText: 'Phone Number',
                              labelStyle: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? kJungleCream.withValues(alpha: 0.6) 
                                    : Colors.grey[600],
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? kJungleCream.withValues(alpha: 0.1) 
                                      : Colors.transparent,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: kJungleEmerald,
                                  width: 1.5,
                                ),
                              ),
                              counterText: "",
                            ),
                            initialCountryCode: 'IN',
                            onChanged: (phone) {
                              controllers.fullPhoneNo.value = phone.completeNumber;
                              controllers.showPassword.value = phone.number.length >= 7;
                            },
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? kJungleCream 
                                  : Colors.black87,
                            ),
                            dropdownTextStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness == Brightness.dark 
                                ? kJungleCream 
                                : Colors.black87,
                            ),
                            dropdownIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? kJungleEmerald 
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),

            // 4. Password
            Obx(() => _animatedField(
                  show: controllers.showPassword.value,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      FormFieldWidget(
                          model: Fieldformmodel(
                              field: controllers.password,
                              label: 'Password',
                              preicon: Icons.lock_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) return "Password is required";
                                if (value.length < 6) return "Password must be at least 6 characters";
                                return null;
                              })),
                    ],
                  ),
                )),

            // 5. Confirm Password
            Obx(() => _animatedField(
                  show: controllers.showConfirmPassword.value,
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      FormFieldWidget(
                          model: Fieldformmodel(
                              field: controllers.conpassword,
                              label: 'Confirm Password',
                              preicon: Icons.lock_clock_rounded,
                              validator: (value) {
                                if (value != controllers.password.text) return "Passwords do not match";
                                return null;
                              })),
                    ],
                  ),
                )),

            const SizedBox(height: 30),
            
            // 6. Final Submit Button
            Obx(() => _animatedField(
                  show: controllers.showSubmit.value,
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () {
                          if (signupKey.currentState!.validate()) {
                            final user = UserModel(
                                fullName: controllers.fullName.text.trim(),
                                email: controllers.email.text.trim(),
                                phoneNo: controllers.fullPhoneNo.value.trim(),
                                password: controllers.password.text.trim());

                            SignUpController.instance.registerUser(user);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kJungleEmerald,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 10,
                          shadowColor: kJungleEmerald.withValues(alpha: 0.4),
                        ),
                        child: Text("sign up".toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.2,
                            ))),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  // Helper widget for smooth animations
  Widget _animatedField({required bool show, required Widget child}) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: show ? child : const SizedBox.shrink(),
      ),
    );
  }
}
