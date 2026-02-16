import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class JungleLoadingOverlay extends StatelessWidget {
  final String message;
  final String? animation;

  const JungleLoadingOverlay({
    super.key,
    this.message = "Verifying Credentials...",
    this.animation = "assets/animation/splashscreen2.json",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: kJungleMossDark.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: kJungleEmerald.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: kJungleEmerald.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 180,
                child: Lottie.asset(
                  animation!,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: kJungleCream,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please wait while we secure your session",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 25),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(kJungleEmerald),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
