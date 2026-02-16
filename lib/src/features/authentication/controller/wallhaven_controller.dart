import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/wallpaper_model.dart';

class WallhavenController extends GetxController {
  static WallhavenController get instance => Get.find();

  final RxList<Photo> wallhavenPhotos = <Photo>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  int _currentPage = 1;
  String _currentQuery = '';

  bool _isSafe(Photo photo) {
    final lowerUrl = photo.photographerUrl.toLowerCase();
    final lowerSrc = photo.src.original.toLowerCase();
    
    final blackList = [
      'people', 'person', 'man', 'woman', 'model', 'human', 'face', 'portrait', 
      'selfie', 'girl', 'boy', 'adult'
    ];
    
    for (var word in blackList) {
      if (lowerUrl.contains(word) || lowerSrc.contains(word)) {
        return false;
      }
    }
    
    return true;
  }

  Future<void> fetchWallhavenWallpapers(String query, {bool isRefresh = true}) async {
    if (query.isEmpty) return;
    if (isLoadingMore.value || (isRefresh && isLoading.value)) return;

    _currentQuery = query;

    try {
      if (isRefresh) {
        _currentPage = 1;
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Wallhaven parameters:
      // categories=110 (General, Anime, No People)
      // purity=100 (SFW)
      // sorting=relevance (Highest context match)
      // per_page=60 (Max allowed for standard API keys)
      String url = 'https://wallhaven.cc/api/v1/search?q=$query&categories=110&purity=100&page=$_currentPage&sorting=toplist&topRange=1M';
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final wallhavenResponse = WallhavenResponse.fromJson(data);

        if (isRefresh) {
          wallhavenPhotos.value = wallhavenResponse.photos
              .where((photo) => _isSafe(photo))
              .toList();
        } else {
          final currentIds = wallhavenPhotos.map((e) => e.id).toSet();
          final newPhotos = wallhavenResponse.photos
              .where((photo) => !currentIds.contains(photo.id) && _isSafe(photo))
              .toList();
          wallhavenPhotos.addAll(newPhotos);
        }
        
        if (wallhavenResponse.photos.isNotEmpty) {
          _currentPage++;
        }
      }
    } catch (e) {
      debugPrint('Wallhaven Error: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && _currentQuery.isNotEmpty) {
      fetchWallhavenWallpapers(_currentQuery, isRefresh: false);
    }
  }
}
