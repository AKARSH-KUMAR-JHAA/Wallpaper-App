import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:luminawall/src/constants/colors_strings.dart';

class RatingController extends GetxController {
  static RatingController get instance => Get.find();

  final _storage = GetStorage();
  final String _lastPromptKey = 'last_rating_prompt_time';
  final String _hasRatedKey = 'has_user_rated';

  @override
  void onInit() {
    super.onInit();
    _startRatingTimer();
  }

  void _startRatingTimer() {
    // Show after 5 minutes (300 seconds)
    Timer(const Duration(minutes: 5), () {
      _checkAndShowRatingDialog();
    });
  }

  void _checkAndShowRatingDialog() {
    final bool hasRated = _storage.read(_hasRatedKey) ?? false;
    if (hasRated) return;

    final String? lastPromptStr = _storage.read(_lastPromptKey);
    if (lastPromptStr != null) {
      final lastPrompt = DateTime.parse(lastPromptStr);
      final nextAllowedPrompt = lastPrompt.add(const Duration(hours: 24));
      
      if (DateTime.now().isBefore(nextAllowedPrompt)) {
        debugPrint("Rating dialog skipped: 24h cooldown not yet passed.");
        return;
      }
    }

    _showRatingDialog();
  }

  void _showRatingDialog() {
    if (Get.context == null) return;

    Get.dialog(
      AlertDialog(
        backgroundColor: kJungleDeepGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Enjoying LuminaWall?",
          style: TextStyle(color: kJungleCream, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "If you love our wallpapers, please take a moment to rate us on the Play Store. It helps us grow!",
          style: TextStyle(color: kJungleCream, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _storage.write(_lastPromptKey, DateTime.now().toIso8601String());
              Get.back();
            },
            child: Text(
              "MAYBE LATER",
              style: TextStyle(color: kJungleCream.withValues(alpha: 0.6)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kJungleEmerald,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _storage.write(_hasRatedKey, true);
              _launchPlayStore();
              Get.back();
            },
            child: const Text("RATE NOW"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _launchPlayStore() async {
    const String appId = "com.wall.lumina";
    final Uri url = Uri.parse("https://play.google.com/store/apps/details?id=$appId");
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint("Error launching Play Store: $e");
    }
  }
}
