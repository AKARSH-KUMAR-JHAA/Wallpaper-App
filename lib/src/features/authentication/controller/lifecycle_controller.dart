import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LifecycleController extends GetxController with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Clear cache only when the app is detached to avoid deleting files 
    // while they are being used by background processes (like setting wallpaper)
    if (state == AppLifecycleState.detached) {
      _clearAppCache();
    }
  }

  Future<void> _clearAppCache() async {
    try {
      debugPrint('Cleaning app cache as user left the app...');
      await DefaultCacheManager().emptyCache();
      debugPrint('Cache cleared successfully.');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }
}
