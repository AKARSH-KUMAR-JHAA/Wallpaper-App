import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:luminawall/src/features/authentication/controller/trending_controller.dart';
import '../../../constants/colors_strings.dart';
import '../models/wallpaper_model.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find();
  
  final _storage = GetStorage();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  String get _key => 'favorites_${_auth.currentUser?.uid ?? "guest"}';
  
  // List of favorite photo objects (Static)
  var favorites = <Photo>[].obs;
  // List of favorite video objects (Live)
  var favoritesLive = <Video>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 1. If user is already logged in, sync immediately
    if (_auth.currentUser != null) {
      loadFavorites();
      syncFromFirestore();
    }
    
    // 2. Listen to auth changes for future login/logout events
    _auth.userChanges().listen((user) {
      debugPrint("FavoritesController: Auth state changed - User: ${user?.uid}");
      if (user != null) {
        loadFavorites();
        syncFromFirestore();
      } else {
        favorites.clear();
        favoritesLive.clear();
      }
    });
  }

  // ... (isFavorite methods remain the same)
  // Check if a photo is already in favorites
  bool isFavorite(String id) {
    return favorites.any((photo) => photo.id == id);
  }

  // Check if a video is already in favorites
  bool isFavoriteLive(String id) {
    return favoritesLive.any((video) => video.id == id);
  }

  // Toggle static favorite status
  Future<void> toggleFavorite(Photo photo) async {
    final user = _auth.currentUser;
    if (user == null) {
      _showLoginWarning();
      return;
    }

    try {
      final String docId = photo.id.toString();
      final path = "Users/${user.uid}/Favorites/$docId";
      
      if (isFavorite(docId)) {
        debugPrint("Removing from favorites: $path");
        favorites.removeWhere((p) => p.id == docId);
        await _db.collection("Users").doc(user.uid).collection("Favorites").doc(docId).delete();
        await _updateGlobalLikeCount(photo, false); // Decrease global count
        Fluttertoast.showToast(msg: "Removed from favorites");
      } else {
        debugPrint("Adding to favorites: $path");
        favorites.add(photo);
        await _db.collection("Users").doc(user.uid).collection("Favorites").doc(docId).set(photo.toJson());
        await _updateGlobalLikeCount(photo, true); // Increase global count
        Fluttertoast.showToast(msg: "Added to favorites!");
      }
      saveToLocal();
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
      Fluttertoast.showToast(msg: "Failed to update favorites: $e");
    }
  }

  // Helper to update global trending count
  Future<void> _updateGlobalLikeCount(Photo photo, bool isAdding) async {
    try {
      final docId = photo.id.toString();
      final docRef = _db.collection("GlobalTrending").doc(docId);
      
      // Optimistically update local TrendingController if it exists
      try {
        final trendingController = Get.find<TrendingController>();
        final currentLikes = trendingController.likesCounts[docId] ?? 0;
        trendingController.likesCounts[docId] = isAdding ? currentLikes + 1 : currentLikes - 1;
      } catch (_) {}

      if (isAdding) {
        await docRef.set({
          'likesCount': FieldValue.increment(1),
          'photoData': photo.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
          'type': 'static',
        }, SetOptions(merge: true));
      } else {
        await docRef.update({
          'likesCount': FieldValue.increment(-1),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint("Global Like Update Error: $e");
    }
  }

  // Toggle live favorite status
  Future<void> toggleFavoriteLive(Video video) async {
    final user = _auth.currentUser;
    if (user == null) {
      _showLoginWarning();
      return;
    }

    try {
      final String docId = video.id.toString();
      final path = "Users/${user.uid}/FavoritesLive/$docId";

      if (isFavoriteLive(docId)) {
        debugPrint("Removing from live favorites: $path");
        favoritesLive.removeWhere((v) => v.id == docId);
        await _db.collection("Users").doc(user.uid).collection("FavoritesLive").doc(docId).delete();
        Fluttertoast.showToast(msg: "Removed from favorites");
      } else {
        debugPrint("Adding to live favorites: $path");
        favoritesLive.add(video);
        await _db.collection("Users").doc(user.uid).collection("FavoritesLive").doc(docId).set(video.toJson());
        Fluttertoast.showToast(msg: "Added to favorites!");
      }
      saveToLocal();
    } catch (e) {
      debugPrint("Error toggling live favorite: $e");
      Fluttertoast.showToast(msg: "Failed to update favorites: $e");
    }
  }

  void _showLoginWarning() {
    Fluttertoast.showToast(
      msg: "Login Required: Please login to save favorites permanently.",
      backgroundColor: Colors.orange.withValues(alpha: 0.9),
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  // Save favorites to local storage
  void saveToLocal() {
    final user = _auth.currentUser;
    if (user == null) return;
    
    try {
      List<String> jsonList = favorites.map((photo) => jsonEncode(photo.toJson())).toList();
      _storage.write(_key, jsonList);

      List<String> jsonListLive = favoritesLive.map((video) => jsonEncode(video.toJson())).toList();
      _storage.write('${_key}_live', jsonListLive);
    } catch (e) {
      debugPrint("Error saving to local storage: $e");
    }
  }

  // Load favorites from local storage
  void loadFavorites() {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      List<dynamic>? storedList = _storage.read<List<dynamic>>(_key);
      if (storedList != null) {
        favorites.value = storedList
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

      List<dynamic>? storedListLive = _storage.read<List<dynamic>>('${_key}_live');
      if (storedListLive != null) {
        favoritesLive.value = storedListLive
            .map((item) {
              try {
                return Video.fromJson(jsonDecode(item as String));
              } catch (e) {
                return null;
              }
            })
            .whereType<Video>()
            .toList();
      }
    } catch (e) {
      debugPrint("Error loading from local storage: $e");
    }
  }

  // Sync from Firestore to get cloud data
  Future<void> syncFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("FavoritesController: No user logged in, sync aborted.");
      return;
    }

    try {
      debugPrint("Syncing favorites from Firestore for user: ${user.uid}");
      
      // 1. Try "Users" (Capitalized) - As seen in your screenshot
      QuerySnapshot snapshot = await _db.collection("Users").doc(user.uid).collection("Favorites").get();
      
      // 2. Fallback for lowercase sub-collection if needed
      if (snapshot.docs.isEmpty) {
        snapshot = await _db.collection("Users").doc(user.uid).collection("favorites").get();
      }

      final List<Photo> syncedPhotos = snapshot.docs.map((doc) {
        try {
          return Photo.fromJson(doc.data() as Map<String, dynamic>);
        } catch (e) {
          debugPrint("Failed to parse Photo from doc ${doc.id}: $e");
          return null;
        }
      }).whereType<Photo>().toList();
      
      favorites.value = syncedPhotos;
      
      // Sync live favorites - Primary: capitalized root and sub-collection
      QuerySnapshot snapshotLive = await _db.collection("Users").doc(user.uid).collection("FavoritesLive").get();
      
      // Fallback for lowercase sub-collection
      if (snapshotLive.docs.isEmpty) {
        snapshotLive = await _db.collection("Users").doc(user.uid).collection("favoritesLive").get();
      }

      final List<Video> syncedVideos = snapshotLive.docs.map((doc) {
        try {
          return Video.fromJson(doc.data() as Map<String, dynamic>);
        } catch (e) {
          debugPrint("Failed to parse Video from doc ${doc.id}: $e");
          return null;
        }
      }).whereType<Video>().toList();

      favoritesLive.value = syncedVideos;
      
      saveToLocal();
      
      debugPrint("Favorites synced from '${snapshot.docs.isNotEmpty ? "Users/users" : "N/A"}': ${favorites.length} wallpapers, ${favoritesLive.length} live");
      
      if (favorites.isNotEmpty || favoritesLive.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Synced ${favorites.length + favoritesLive.length} cloud favorites!",
          backgroundColor: kJungleEmerald.withValues(alpha: 0.8),
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } catch (e) {
      debugPrint("Critical error syncing favorites: $e");
      Fluttertoast.showToast(
        msg: "Sync failed: Please check your connection.",
        backgroundColor: Colors.red.withValues(alpha: 0.8),
      );
    }
  }
}
