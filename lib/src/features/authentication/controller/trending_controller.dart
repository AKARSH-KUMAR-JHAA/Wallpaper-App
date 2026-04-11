import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/wallpaper_model.dart';
import 'bottom_nav_controller.dart';

class TrendingController extends GetxController with WidgetsBindingObserver {
  static TrendingController get instance => Get.find();
  
  final _db = FirebaseFirestore.instance;
  StreamSubscription? _trendingSubscription;
  
  // High-level list of top trending photos
  final topPhotos = <Photo>[].obs;
  final likesCounts = <String, int>{}.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    
    // Start real-time global synchronization
    _listenToGlobalTrending();

    // Listen for tab entries from BottomNavController (if needed for resets)
    try {
      final navControl = Get.find<BottomNavController>();
      ever(navControl.currentIndex, (int index) {
        if (index == 2) {
          // Re-trigger sync if needed, but stream should handle it
        }
      });
    } catch (_) {}
  }

  @override
  void onClose() {
    _trendingSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _listenToGlobalTrending() {
    _trendingSubscription?.cancel();
    isLoading.value = true;
    
    _trendingSubscription = _db.collection("GlobalTrending")
        .where("likesCount", isGreaterThan: 0)
        .orderBy("likesCount", descending: true)
        .limit(50)
        .snapshots()
        .listen((snapshot) {
          final List<Photo> photos = [];
          final Map<String, int> counts = {};

          for (var doc in snapshot.docs) {
            final data = doc.data();
            if (data['photoData'] != null) {
              final photo = Photo.fromJson(data['photoData'] as Map<String, dynamic>);
              photos.add(photo);
              counts[photo.id.toString()] = data['likesCount'] ?? 0;
            }
          }
          topPhotos.value = photos;
          likesCounts.value = counts;
          isLoading.value = false;
        }, onError: (error) {
          debugPrint("Global Trending Sync Error: $error");
          isLoading.value = false;
        });
  }

  // Compatibility method for existing manual calls
  Future<void> fetchGlobalTrending() async {
    _listenToGlobalTrending();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-initialize stream for fresh data on reopen
      _listenToGlobalTrending();
    }
  }

  int getLikes(String id) => likesCounts[id] ?? 0;
  
  // Helper to force index in top list locally for optimistic UI
  void updateLocalCount(String id, int increment) {
    if (likesCounts.containsKey(id)) {
      likesCounts[id] = (likesCounts[id] ?? 0) + increment;
      likesCounts.refresh();
    }
  }
}
