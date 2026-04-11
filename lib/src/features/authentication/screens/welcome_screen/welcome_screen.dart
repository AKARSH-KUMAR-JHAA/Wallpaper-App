import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:luminawall/src/constants/animation_strings.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/screens/login_screen/login_screen.dart';
import 'package:luminawall/src/features/authentication/screens/sighup_screen/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Forest Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark ? [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ] : [
                    Colors.white,
                    kJungleCream,
                  ],
                ),
              ),
            ),
          ),

          // Top Lottie
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: isDark ? 0.6 : 0.4,
              child: Lottie.asset(
                welcomeAni1,
                height: size.height * 0.35,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // Bottom Lottie
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: isDark ? 0.5 : 0.3,
              child: Lottie.asset(
                welcomeAni2,
                height: size.height * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Center Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                // Middle Lottie (The "Feature")
                SizedBox(
                  height: size.height * 0.3,
                  child: Lottie.asset(
                    welcomeAni3,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  welcomeheadline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: isDark ? kJungleCream : kJungleGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: isDark ? Colors.black.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.1),
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  welcomebody,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? kJungleCream.withValues(alpha: 0.8) : kJungleDeepGreen.withValues(alpha: 0.8),
                    fontSize: 18,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 150),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () => Get.to(() => const LoginScreen()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kJungleEmerald,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 10,
                          ),
                          child: Text(
                            login.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () => Get.to(() => const SignupScreen()),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? kJungleCream : kJungleGreen,
                            side: BorderSide(color: isDark ? kJungleCream : kJungleGreen, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            signup.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
