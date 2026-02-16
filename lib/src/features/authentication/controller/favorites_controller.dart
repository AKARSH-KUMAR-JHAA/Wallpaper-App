import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/wallpaper_model.dart';
import 'dart:convert';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find();
  
  final _storage = GetStorage();
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  String get _key => 'favorites_${_auth.currentUser?.uid ?? "guest"}';
  
  // List of favorite photo objects
  var favorites = <Photo>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to auth changes to reload favorites
    _auth.userChanges().listen((user) {
      if (user != null) {
        loadFavorites();
        syncFromFirestore();
      } else {
        favorites.clear();
      }
    });
  }

  // Check if a photo is already in favorites
  bool isFavorite(String id) {
    return favorites.any((photo) => photo.id == id);
  }

  // Toggle favorite status
  Future<void> toggleFavorite(Photo photo) async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Login Required", "Please login to save favorites permanently.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (isFavorite(photo.id)) {
      favorites.removeWhere((p) => p.id == photo.id);
      await _db.collection("Users").doc(user.uid).collection("Favorites").doc(photo.id).delete();
    } else {
      favorites.add(photo);
      await _db.collection("Users").doc(user.uid).collection("Favorites").doc(photo.id).set(photo.toJson());
    }
    saveToLocal();
  }

  // Save favorites to local storage
  void saveToLocal() {
    final user = _auth.currentUser;
    if (user == null) return;
    
    List<String> jsonList = favorites.map((photo) => jsonEncode(photo.toJson())).toList();
    _storage.write(_key, jsonList);
  }

  // Load favorites from local storage
  void loadFavorites() {
    final user = _auth.currentUser;
    if (user == null) return;

    List<dynamic>? storedList = _storage.read<List<dynamic>>(_key);
    if (storedList != null) {
      favorites.value = storedList
          .map((item) => Photo.fromJson(jsonDecode(item as String)))
          .toList();
    }
  }

  // Sync from Firestore to get cloud data
  Future<void> syncFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _db.collection("Users").doc(user.uid).collection("Favorites").get();
      final List<Photo> cloudFavorites = snapshot.docs.map((doc) => Photo.fromJson(doc.data())).toList();
      
      // Update local if cloud has more/different data
      favorites.value = cloudFavorites;
      saveToLocal();
    } catch (e) {
      if (kDebugMode) {
        print("Error syncing favorites: $e");
      }
    }
  }
}
