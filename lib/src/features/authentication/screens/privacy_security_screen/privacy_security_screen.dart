import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/common_widget/standard_header.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kJungleMossDark,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: kJungleCream),
                  ),
                  const Expanded(child: StandardHeader(title: "Privacy & Security")),
                  const SizedBox(width: 48), // Balance
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 30),
                    _buildSectionHeader("DATA PRIVACY"),
                    _buildSecurityTile(
                      icon: Icons.visibility_off_outlined,
                      title: "Incognito Mode",
                      subtitle: "Don't save my search history",
                      trailing: Switch(value: false, onChanged: (v) {}, activeThumbColor: kJungleEmerald),
                    ),
                    _buildSecurityTile(
                      icon: Icons.delete_outline_rounded,
                      title: "Clear All Data",
                      subtitle: "Permanently delete your app cache",
                      onTap: () {},
                    ),
                    const SizedBox(height: 30),
                    _buildSectionHeader("SECURITY"),
                    _buildSecurityTile(
                      icon: Icons.fingerprint_rounded,
                      title: "Biometric Lock",
                      subtitle: "Unlock app with Fingerprint/FaceID",
                      trailing: Switch(value: true, onChanged: (v) {}, activeThumbColor: kJungleEmerald),
                    ),
                    _buildSecurityTile(
                      icon: Icons.phonelink_lock_rounded,
                      title: "Two-Factor Auth",
                      subtitle: "Enhanced account protection",
                      onTap: () {},
                    ),
                    const SizedBox(height: 30),
                    _buildSectionHeader("LEGAL"),
                    _buildSecurityTile(
                      icon: Icons.description_outlined,
                      title: "Terms of Service",
                      onTap: () {},
                    ),
                    _buildSecurityTile(
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      onTap: () {},
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: Text(
                        "Your privacy is our priority. LuminaWall never sells your data.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kJungleCream.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: kJungleEmerald,
          fontWeight: FontWeight.w900,
          fontSize: 12,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSecurityTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kJungleCream.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kJungleEmerald.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: kJungleEmerald, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(color: kJungleCream, fontWeight: FontWeight.bold),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: kJungleCream.withValues(alpha: 0.5), fontSize: 12),
              )
            : null,
        trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      ),
    );
  }
}
