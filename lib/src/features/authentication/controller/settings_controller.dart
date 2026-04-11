import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/colors_strings.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  final _box = GetStorage();

  static const _notifKey = 'notifications_enabled';
  static const _qualityKey = 'download_quality';

  final RxBool notificationsEnabled = false.obs;
  final RxString downloadQuality = 'Original (4K)'.obs;
  final RxString cacheSize = 'Calculating...'.obs;

  final List<String> qualityOptions = [
    'Low (720p)',
    'Medium (1080p)',
    'High (2K)',
    'Original (4K)',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _syncNotificationPermission();
    refreshCacheSize();
  }

  // ─── Settings Persistence ────────────────────────────────────────────────────

  void _loadSettings() {
    downloadQuality.value = _box.read(_qualityKey) ?? 'Original (4K)';
  }

  // ─── Notifications ────────────────────────────────────────────────────────────

  Future<void> _syncNotificationPermission() async {
    final status = await Permission.notification.status;
    notificationsEnabled.value = status.isGranted;
    _box.write(_notifKey, status.isGranted);
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        notificationsEnabled.value = true;
        _box.write(_notifKey, true);
        _toast('Notifications enabled ✅', kJungleEmerald);
        return;
      }
      if (status.isDenied) {
        final result = await Permission.notification.request();
        if (result.isGranted) {
          notificationsEnabled.value = true;
          _box.write(_notifKey, true);
          _toast('Notifications enabled ✅', kJungleEmerald);
        } else {
          notificationsEnabled.value = false;
          _box.write(_notifKey, false);
          _showSettingsDialog(
            title: 'Permission Denied',
            message:
                'To enable notifications, go to:\nSettings → Apps → LuminaWall → Notifications → Enable',
          );
        }
        return;
      }
      if (status.isPermanentlyDenied) {
        notificationsEnabled.value = false;
        _box.write(_notifKey, false);
        _showSettingsDialog(
          title: 'Enable Notifications',
          message:
              'Notifications are blocked. Go to:\nSettings → Apps → LuminaWall → Notifications → Enable',
        );
        return;
      }
    } else {
      _showSettingsDialog(
        title: 'Disable Notifications',
        message:
            'To disable notifications, go to:\nSettings → Apps → LuminaWall → Notifications → Disable',
      );
      Future.delayed(const Duration(seconds: 2), _syncNotificationPermission);
    }
  }

  void _showSettingsDialog({required String title, required String message}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.isDarkMode ? kJungleMossDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: TextStyle(
                color: Get.isDarkMode ? kJungleCream : kJungleMossDark,
                fontWeight: FontWeight.bold)),
        content: Text(message,
            style: TextStyle(
                color: (Get.isDarkMode ? kJungleCream : kJungleMossDark)
                    .withValues(alpha: 0.7),
                height: 1.6)),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel',
                  style: TextStyle(
                      color: (Get.isDarkMode ? kJungleCream : kJungleMossDark)
                          .withValues(alpha: 0.5)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: kJungleEmerald,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Download Quality ─────────────────────────────────────────────────────────

  void setDownloadQuality(String quality) {
    downloadQuality.value = quality;
    _box.write(_qualityKey, quality);
    _toast('Download quality set to $quality 📷', kJungleEmerald);
  }

  String getDownloadUrl({
    required String original,
    required String large2x,
    required String large,
    required String medium,
  }) {
    switch (downloadQuality.value) {
      case 'Low (720p)':
        return medium.isNotEmpty ? medium : original;
      case 'Medium (1080p)':
        return large.isNotEmpty ? large : original;
      case 'High (2K)':
        return large2x.isNotEmpty ? large2x : original;
      case 'Original (4K)':
      default:
        // Optimization for Pexels to get exactly 4K pixels
        if (original.contains('pexels.com')) {
          // If it already has parameters, keep them and add 4K ones
          final separator = original.contains('?') ? '&' : '?';
          return "$original${separator}auto=compress&cs=tinysrgb&fit=crop&h=3840&w=2160";
        }
        return original;
    }
  }

  // ─── Cache Directories ────────────────────────────────────────────────────────

  /// Returns ALL cache directories Android tracks under Settings → App → Cache.
  /// This includes internal cache AND every external cache dir.
  Future<List<Directory>> _getAllCacheDirs() async {
    final seen = <String>{};
    final result = <Directory>[];

    void addDir(Directory d) {
      if (seen.add(d.path)) result.add(d);
    }

    // 1. Internal cache dir  (getCacheDir on Android, Library/Caches on iOS)
    try {
      addDir(await getTemporaryDirectory());
    } catch (_) {}

    // 2. Application cache dir – same as above on Android but include anyway
    try {
      addDir(await getApplicationCacheDirectory());
    } catch (_) {}

    // 3. External cache dirs – THIS is where the 111 MB likely lives on Android
    //    e.g. /sdcard/Android/data/com.wall.lumina/cache/
    try {
      final externalCacheDirs = await getExternalCacheDirectories();
      if (externalCacheDirs != null) {
        for (final d in externalCacheDirs) {
          addDir(d);
        }
      }
    } catch (_) {}

    // 4. Application documents dir (just in case any cache ended up there)
    try {
      addDir(await getApplicationDocumentsDirectory());
    } catch (_) {}

    return result;
  }

  // ─── Cache Size ───────────────────────────────────────────────────────────────

  Future<void> refreshCacheSize() async {
    cacheSize.value = 'Calculating...';
    try {
      int totalBytes = 0;
      final dirs = await _getAllCacheDirs();
      for (final dir in dirs) {
        if (!dir.existsSync()) continue;
        final entities = dir.listSync(recursive: true, followLinks: false);
        for (final entity in entities) {
          if (entity is File) {
            try {
              totalBytes += entity.lengthSync();
            } catch (_) {}
          }
        }
      }
      cacheSize.value = _formatBytes(totalBytes);
    } catch (e) {
      cacheSize.value = 'Unknown';
      debugPrint('Cache size error: $e');
    }
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // ─── Clear Cache ──────────────────────────────────────────────────────────────

  Future<void> clearCache() async {
    // Show loading dialog
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: Get.isDarkMode ? kJungleMossDark : Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const CircularProgressIndicator(color: kJungleEmerald),
                const SizedBox(width: 20),
                Text('Clearing cache...',
                    style: TextStyle(
                        color:
                            Get.isDarkMode ? kJungleCream : kJungleMossDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    final errors = <String>[];

    // Step 1: flutter_cache_manager DB + managed files
    try {
      await DefaultCacheManager().emptyCache();
    } catch (e) {
      errors.add('FlutterCacheManager: $e');
      debugPrint('emptyCache error: $e');
    }

    // Step 2: Physically delete ALL cache dirs (internal + external)
    try {
      final dirs = await _getAllCacheDirs();
      for (final dir in dirs) {
        try {
          await _wipeDirectory(dir);
        } catch (e) {
          errors.add('Dir ${dir.path}: $e');
          debugPrint('Wipe dir error ${dir.path}: $e');
        }
      }
    } catch (e) {
      errors.add('getAllCacheDirs: $e');
    }

    // Step 3: Flutter in-memory decoded image cache
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (e) {
      errors.add('ImageCache: $e');
      debugPrint('imageCache error: $e');
    }

    // Close loading dialog
    if (Get.isDialogOpen == true) Get.back();

    // Refresh size display
    await refreshCacheSize();

    if (errors.isEmpty) {
      _toast('Cache cleared successfully 🗑️', kJungleEmerald);
    } else {
      debugPrint('Cache clear partial errors: $errors');
      // Still show partial success — some clearing happened
      _toast('Cache partially cleared (some files in use)', Colors.orange);
    }
  }

  /// Deletes all contents of [dir] without removing the directory itself.
  Future<void> _wipeDirectory(Directory dir) async {
    if (!dir.existsSync()) return;
    final entities = dir.listSync(recursive: false, followLinks: false);
    for (final entity in entities) {
      try {
        if (entity is File) {
          await entity.delete();
        } else if (entity is Directory) {
          await entity.delete(recursive: true);
        }
      } catch (e) {
        debugPrint('Could not delete ${entity.path}: $e');
      }
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

  void _toast(String msg, Color bg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bg,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
