import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/controller/login_controller.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class FooterSignupWidget extends StatelessWidget {
  const FooterSignupWidget({
    super.key,
    required this.size,
    required this.txt1,
    required this.txt2,
    required this.screen,
  });
  final Size size;
  final String txt1;
  final String txt2;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(LoginController());
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Divider(color: (isDark ? kJungleCream : kJungleGreen).withValues(alpha: 0.2))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'OR',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: (isDark ? kJungleCream : kJungleGreen).withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
              ),
              Expanded(
                  child: Divider(color: (isDark ? kJungleCream : kJungleGreen).withValues(alpha: 0.2))),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 55,
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => controller.googleSignIn(),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                side: BorderSide(color: (isDark ? kJungleCream : kJungleGreen).withValues(alpha: 0.3)),
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : kJungleGreen.withValues(alpha: 0.05),
              ),
              icon: const Image(
                image: AssetImage('assets/images/sign_up_images/R.png'),
                height: 24,
              ),
              label: Text(
                'Sign in with Google',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? kJungleCream : kJungleGreen,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: () => Get.offAll(() => screen),
            child: RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: (isDark ? kJungleCream : kJungleGreen).withValues(alpha: 0.7),
                        ),
                    children: [
                  TextSpan(text: '$txt1 '),
                  TextSpan(
                    text: txt2.toUpperCase(),
                    style: const TextStyle(
                      color: kJungleEmerald,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ])),
          )
        ],
      ),
    );
  }
}
