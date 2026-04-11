import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common_widget/standard_header.dart';
import '../../../../../constants/colors_strings.dart';
import '../../../controller/settings_controller.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  final String privacyPolicyUrl =
      "https://doc-hosting.flycricket.io/luminawall-best-wallpaper-app-privacy-policy/3d1422ee-16bd-46ca-a312-fbb15112fada/privacy";

  Future<void> _launchUrl() async {
    try {
      final Uri url = Uri.parse(privacyPolicyUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Theme Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [kJungleDeepGreen, kJungleMossDark]
                      : [Colors.white, kJungleCream],
                ),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              const StandardHeader(title: "Settings"),
              Expanded(
                child: Obx(() => ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 20),

                    // ── Section: Preferences ──────────────────────────────
                    _buildSectionLabel('PREFERENCES', isDark),
                    const SizedBox(height: 12),

                    // Push Notifications Toggle
                    _buildSettingTile(
                      context,
                      icon: Icons.notifications_active_outlined,
                      title: "Push Notifications",
                      subtitle: controller.notificationsEnabled.value
                          ? "Enabled – you'll receive updates"
                          : "Disabled – tap to enable",
                      trailing: Switch(
                        value: controller.notificationsEnabled.value,
                        onChanged: (val) =>
                            controller.toggleNotifications(val),
                        activeThumbColor: kJungleEmerald,
                        activeTrackColor:
                            kJungleEmerald.withValues(alpha: 0.3),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor:
                            Colors.grey.withValues(alpha: 0.3),
                      ),
                    ),

                    // Download Quality
                    _buildSettingTile(
                      context,
                      icon: Icons.file_download_outlined,
                      title: "Download Quality",
                      subtitle: controller.downloadQuality.value,
                      onTap: () =>
                          _showQualityPicker(context, controller, isDark),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: kJungleEmerald.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color:
                                      kJungleEmerald.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              _qualityBadge(
                                  controller.downloadQuality.value),
                              style: const TextStyle(
                                color: kJungleEmerald,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right,
                              color: isDark
                                  ? kJungleCream.withValues(alpha: 0.3)
                                  : kJungleMossDark.withValues(alpha: 0.3)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Section: Storage ──────────────────────────────────
                    _buildSectionLabel('STORAGE', isDark),
                    const SizedBox(height: 12),

                    // Clear Cache
                    _buildSettingTile(
                      context,
                      icon: Icons.storage_outlined,
                      title: "Clear Cache",
                      subtitle: "Free up ${controller.cacheSize.value} of cached data",
                      onTap: () => _showClearCacheConfirm(context, controller, isDark),
                    ),

                    const SizedBox(height: 24),

                    // ── Section: About ────────────────────────────────────
                    _buildSectionLabel('ABOUT', isDark),
                    const SizedBox(height: 12),

                    // Privacy Policy
                    _buildSettingTile(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: "Privacy Policy",
                      onTap: _launchUrl,
                    ),

                    // App Version
                    _buildSettingTile(
                      context,
                      icon: Icons.info_outline,
                      title: "App Version",
                      subtitle: "v1.1.0",
                    ),

                    const SizedBox(height: 40),
                  ],
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Quality badge label ────────────────────────────────────────────────────

  String _qualityBadge(String quality) {
    if (quality.contains('4K') || quality.contains('Original')) return '4K';
    if (quality.contains('2K')) return '2K';
    if (quality.contains('1080')) return 'FHD';
    return 'HD';
  }

  // ─── Clear Cache Confirmation ────────────────────────────────────────────────

  void _showClearCacheConfirm(
    BuildContext context,
    SettingsController controller,
    bool isDark,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? kJungleMossDark : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: kJungleEmerald, size: 26),
            const SizedBox(width: 10),
            Text(
              'Clear Cache',
              style: TextStyle(
                color: isDark ? kJungleCream : kJungleMossDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Obx(() => Text(
          'This will delete ${controller.cacheSize.value} of cached wallpaper images. The app will re-download images as you browse.',
          style: TextStyle(
            color: (isDark ? kJungleCream : kJungleMossDark)
                .withValues(alpha: 0.7),
            height: 1.5,
          ),
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: (isDark ? kJungleCream : kJungleMossDark)
                    .withValues(alpha: 0.5),
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_rounded, color: Colors.white, size: 18),
            label: const Text('Clear Now',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: kJungleEmerald,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              controller.clearCache();
            },
          ),
        ],
      ),
    );
  }

  // ─── Quality Picker Bottom Sheet ────────────────────────────────────────────

  void _showQualityPicker(
    BuildContext context,
    SettingsController controller,
    bool isDark,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
        decoration: BoxDecoration(
          color: isDark ? kJungleMossDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Select Download Quality',
              style: TextStyle(
                color: isDark ? kJungleCream : kJungleMossDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose image quality for downloads and wallpaper setting.',
              style: TextStyle(
                color: (isDark ? kJungleCream : kJungleMossDark)
                    .withValues(alpha: 0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Column(
              children: controller.qualityOptions.map((q) {
                final isSelected = controller.downloadQuality.value == q;
                return GestureDetector(
                  onTap: () {
                    controller.setDownloadQuality(q);
                    Get.back();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? kJungleEmerald.withValues(alpha: 0.12)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.04)
                              : Colors.black.withValues(alpha: 0.03)),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? kJungleEmerald
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.07)
                                : Colors.black.withValues(alpha: 0.07)),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _qualityIcon(q),
                          color: isSelected
                              ? kJungleEmerald
                              : (isDark
                                  ? kJungleCream.withValues(alpha: 0.5)
                                  : kJungleMossDark.withValues(alpha: 0.5)),
                          size: 22,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q,
                                style: TextStyle(
                                  color: isSelected
                                      ? kJungleEmerald
                                      : (isDark
                                          ? kJungleCream
                                          : kJungleMossDark),
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                _qualityDescription(q),
                                style: TextStyle(
                                  color: (isDark
                                          ? kJungleCream
                                          : kJungleMossDark)
                                      .withValues(alpha: 0.45),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded,
                              color: kJungleEmerald, size: 22),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  IconData _qualityIcon(String q) {
    if (q.contains('Low')) return Icons.sd_card_outlined;
    if (q.contains('Medium')) return Icons.hd_outlined;
    if (q.contains('High')) return Icons.two_k_outlined;
    return Icons.four_k_outlined;
  }

  String _qualityDescription(String q) {
    switch (q) {
      case 'Low (720p)':
        return 'Saves data, smaller file size';
      case 'Medium (1080p)':
        return 'Balanced quality & size';
      case 'High (2K)':
        return 'Crisp quality for most screens';
      case 'Original (4K)':
        return 'Best quality, larger file size';
      default:
        return '';
    }
  }

  // ─── Section Label ──────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: isDark ? kJungleEmerald : kJungleGreen,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? kJungleCream.withValues(alpha: 0.5) : kJungleMossDark.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Setting Tile ───────────────────────────────────────────────────────────

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? kJungleMossDark.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: kJungleEmerald.withValues(alpha: isDark ? 0.1 : 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kJungleEmerald.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child:
              Icon(icon, color: isDark ? kJungleEmerald : kJungleGreen),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? kJungleCream : kJungleMossDark,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? kJungleCream.withValues(alpha: 0.45)
                      : kJungleMossDark.withValues(alpha: 0.45),
                  fontSize: 12,
                ),
              )
            : null,
        trailing: trailing ??
            Icon(Icons.chevron_right,
                color: isDark
                    ? kJungleCream.withValues(alpha: 0.3)
                    : kJungleMossDark.withValues(alpha: 0.3)),
        onTap: onTap,
      ),
    );
  }
}
