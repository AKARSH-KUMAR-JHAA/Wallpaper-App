

import 'package:flutter/material.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

import '../../../../../common_widget/standard_header.dart';

class AboutUsTab extends StatelessWidget {
  const AboutUsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? kJungleMossDark : Colors.white,
      body: Stack(
        children: [
          // Theme Background
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

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              const StandardHeader(title: "About Us"),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: kJungleEmerald.withValues(alpha: 0.2),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  )
                                ],
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/logo/playstore.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Text(
                              "LUMINA WALL",
                              style: TextStyle(
                                    color: isDark ? kJungleCream : kJungleMossDark,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                            ),
                            Text(
                              "VERSION 1.0.0",
                              style: TextStyle(
                                color: (isDark ? kJungleCream : kJungleMossDark).withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildSectionHeader(context, "OUR MISSION"),
                      const SizedBox(height: 15),
                      Text(
                        "LuminaWall was born out of a passion for digital art and personalization. We believe that your phone's wallpaper is a reflection of your mood, your style, and your vibe. Our mission is to provide the highest quality 4K wallpapers from the best photographers worldwide, right at your fingertips.",
                        style: TextStyle(
                              height: 1.8,
                              color: (isDark ? kJungleCream : kJungleMossDark).withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 35),
                      _buildSectionHeader(context, "CONNECTED WITH PEXELS"),
                      const SizedBox(height: 15),
                      Text(
                        "All our images are served by the Pexels API, ensuring a diverse and constantly updated collection of stunning visuals under the Pexels License.",
                        style: TextStyle(
                              height: 1.8,
                              color: (isDark ? kJungleCream : kJungleMossDark).withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: Text(
                          "MADE WITH ❤️ BY AKARSH",
                          style: TextStyle(
                                color: (isDark ? kJungleEmerald : kJungleGreen).withValues(alpha: 0.8),
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                fontSize: 11,
                              ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 3,
          height: 15,
          color: isDark ? kJungleEmerald : kJungleGreen,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: isDark ? kJungleEmerald : kJungleGreen,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
