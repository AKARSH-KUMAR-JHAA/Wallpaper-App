
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/animation_strings.dart';
import '../../../../constants/colors_strings.dart';
import '../../../../constants/text_strings.dart';
import '../../../../repository/authentication_repository/authentication_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Reduced timer to 4 seconds for a snapper feel
    Timer(const Duration(seconds: 4), () {
      AuthenticationRepository.instance.hasrunfun();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Deep Jungle Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kJungleDeepGreen,
                  kJungleMossDark,
                  Colors.black,
                ],
              ),
            ),
          ),
          
          // Subtle Nature Decorative Icons
          Positioned(
            top: -50,
            left: -50,
            child: Opacity(
              opacity: 0.05,
              child: Icon(Icons.eco, size: 250, color: kJungleEmerald),
            ),
          ),
          Positioned(
            bottom: -30,
            right: -40,
            child: Opacity(
              opacity: 0.05,
              child: Icon(Icons.eco_rounded, size: 200, color: kJungleEmerald),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Lottie Logo
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SizedBox(
                      height: 320,
                      child: Lottie.asset(
                        splashAni1,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 0), // Adjust spacing based on Lottie layout

                // App Identity
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        welcomeheadline.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: kJungleCream,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: kJungleEmerald.withValues(alpha: 0.6),
                              blurRadius: 30,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: kJungleCream.withValues(alpha: 0.15),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Text(
                          "PREMIUM NATURE WALLPAPERS",
                          style: TextStyle(
                            color: kJungleCream.withValues(alpha: 0.5),
                            fontSize: 11,
                            letterSpacing: 5,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Minimalist Loading Indicator at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      kJungleEmerald.withValues(alpha: 0.5)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
