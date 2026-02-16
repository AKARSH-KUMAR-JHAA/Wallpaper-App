

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common_widget/standard_header.dart';
import '../../../../../constants/colors_strings.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  final String privacyPolicyUrl = "https://doc-hosting.flycricket.io/luminawall-best-wallpaper-app-privacy-policy/3d1422ee-16bd-46ca-a312-fbb15112fada/privacy";

  Future<void> _launchUrl() async {
    try {
      final Uri url = Uri.parse(privacyPolicyUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kJungleMossDark,
      body: Stack(
        children: [
          // Theme Background
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
              const StandardHeader(title: "Settings"),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 20),
                    _buildSettingTile(
                      context,
                      icon: Icons.notifications_active_outlined,
                      title: "Push Notifications",
                      trailing: Switch(
                        value: true, 
                        onChanged: (val) {},
                        activeColor: kJungleEmerald,
                        activeTrackColor: kJungleEmerald.withValues(alpha: 0.3),
                      ),
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.file_download_outlined,
                      title: "Download Quality",
                      subtitle: "Ultra HD (4K)",
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.storage_outlined,
                      title: "Clear Cache",
                      subtitle: "Free up 240 MB",
                      onTap: () {},
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      onTap: _launchUrl,
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.info_outline,
                      title: "App Version",
                      subtitle: "v1.0.4",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kJungleMossDark.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kJungleEmerald.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kJungleEmerald.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: kJungleEmerald),
        ),
        title: Text(
          title, 
          style: const TextStyle(
            color: kJungleCream,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null ? Text(
          subtitle, 
          style: TextStyle(
            color: kJungleCream.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ) : null,
        trailing: trailing ?? Icon(Icons.chevron_right, color: kJungleCream.withValues(alpha: 0.3)),
        onTap: onTap,
      ),
    );
  }
}
