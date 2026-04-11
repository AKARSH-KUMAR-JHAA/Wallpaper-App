import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/wallpaper_model.dart';
import 'package:luminawall/src/features/authentication/controller/wallpaper_controller.dart';
import 'dart:math';

class RewardsController extends GetxController {
  static RewardsController get instance => Get.find();

  final _storage = GetStorage();
  final String _storageKey = 'unlocked_rewards';

  // Observable list of unlocked photos
  var unlockedRewards = <Photo>[].obs;
  
  // Track if we're currently unlocking something
  var isUnlocking = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRewards();
  }

  void loadRewards() {
    try {
      List<dynamic>? storedList = _storage.read<List<dynamic>>(_storageKey);
      if (storedList != null) {
        unlockedRewards.value = storedList
            .map((item) {
              try {
                return Photo.fromJson(jsonDecode(item as String));
              } catch (e) {
                return null;
              }
            })
            .whereType<Photo>()
            .toList();
      }
    } catch (e) {
      debugPrint("Error loading rewards: $e");
    }
  }

  void saveRewards() {
    try {
      List<String> jsonList = unlockedRewards.map((photo) => jsonEncode(photo.toJson())).toList();
      _storage.write(_storageKey, jsonList);
    } catch (e) {
      debugPrint("Error saving rewards: $e");
    }
  }

  Future<Photo?> unlockRandomReward() async {
    isUnlocking.value = true;
    try {
      final wallpaperController = Get.put(WallpaperController());
      
      // If we don't have search photos loaded, load some quickly
      if (wallpaperController.searchPhotos.isEmpty) {
        await wallpaperController.fetchSearchResults('retro aesthetic neon minimalist', isRefresh: true);
      }
      
      final candidates = wallpaperController.searchPhotos;
      if (candidates.isEmpty) {
        // Fallback to latest photos if search fails
        if (wallpaperController.latestPhotos.isEmpty) {
           await wallpaperController.fetchLatestWallpapers(isRefresh: true);
        }
        candidates.addAll(wallpaperController.latestPhotos);
      }

      if (candidates.isNotEmpty) {
        // Pick random
        final random = Random();
        final unlockedPhoto = candidates[random.nextInt(candidates.length)];
        
        // Add to list and save if not already unlocked
        if (!unlockedRewards.any((p) => p.id == unlockedPhoto.id)) {
           unlockedRewards.add(unlockedPhoto);
           saveRewards();
           return unlockedPhoto;
        } else {
           // Provide a new chance 
           return await _unlockAnotherChance(candidates);
        }
      }
    } catch (e) {
      debugPrint("Error unlocking reward: $e");
    } finally {
      isUnlocking.value = false;
    }
    return null;
  }
  
  Future<Photo?> _unlockAnotherChance(List<Photo> candidates) async {
     final random = Random();
     for (var i = 0; i < 5; i++) {
        final photo = candidates[random.nextInt(candidates.length)];
        if (!unlockedRewards.any((p) => p.id == photo.id)) {
           unlockedRewards.add(photo);
           saveRewards();
           return photo;
        }
     }
     // If we failed 5 times, just return the first one available
     return candidates.first;
  }
}
