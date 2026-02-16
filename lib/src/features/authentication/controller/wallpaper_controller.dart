import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/wallpaper_model.dart';

class WallpaperController extends GetxController {
  static WallpaperController get instance => Get.find();

  final String _apiKey = 'q8Zg7n7cTPErS6gqJCWBItSF2k00auOf2A4ew711fZj9FCrWHjvKhI4d'; 
  final RxList<Photo> latestPhotos = <Photo>[].obs;
  final RxList<Photo> curatedPhotos = <Photo>[].obs;
  final RxList<Photo> searchPhotos = <Photo>[].obs;
  final RxList<Video> liveWallpapers = <Video>[].obs;
  
  final RxBool isLoadingLatest = false.obs;
  final RxBool isLoadingCurated = false.obs;
  final RxBool isLoadingSearch = false.obs;
  final RxBool isLoadingVideos = false.obs;
  final RxBool isLoadingMore = false.obs;

  // Pagination variables
  int _latestPage = 1;
  int _curatedPage = 1;
  int _searchPage = 1;
  int _videoPage = 1;
  String _currentSearchQuery = '';

  @override
  void onInit() {
    super.onInit();
    fetchLatestWallpapers();
    fetchCuratedWallpapers();
    fetchLiveWallpapers();
  }

  final List<String> _homeQueries = [
    'pure abstract art wallpaper',
    'aerial nature landscape 8k',
    'clean minimalist aesthetic',
    'amoled black dark texture',
    '3d geometry abstract render',
    'hubble space nebula galaxy',
    'empty city architecture skyline',
    'macro nature texture photography',
    'anime scenery landscape no people',
    'vaporwave synthwave aesthetic',
    'underwater oceanic life coral',
    'northern lights aurora borealis',
    'cyberpunk neon city night',
    'macro flower petals 8k'
  ];

  final List<String> _videoQueries = [
    'abstract 3d motion loop',
    'aerial nature drone scenery',
    'minimalist geometry animation',
    'amoled dark particles loop',
    'space galaxy travel background',
    'empty city night time-lapse',
    'macro nature close-up loop',
    'anime background motion art',
    'waterfall nature relaxation loop',
    'slow motion ink in water'
  ];

  Future<void> fetchLatestWallpapers({bool isRefresh = true}) async {
    if (isLoadingMore.value || (isRefresh && isLoadingLatest.value)) return;

    try {
      if (isRefresh) {
        _latestPage = 1;
        _homeQueries.shuffle(); // Shuffle for maximum randomness
        isLoadingLatest.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Pick 5 random categories for maximum variety on a single load
      final randomQueries = List<String>.from(_homeQueries)..shuffle();
      final selectedQueries = randomQueries.take(5).toList();
      
      List<List<Photo>> multiResults = [];
      
      // Fetch from multiple categories in parallel for speed and variety
      await Future.wait(selectedQueries.map((query) async {
        try {
          final response = await http.get(
            Uri.parse(
                'https://api.pexels.com/v1/search?query=$query&per_page=12&page=$_latestPage&orientation=portrait&locale=en-US'),
            headers: {'Authorization': _apiKey},
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final pexelsResponse = PexelsResponse.fromJson(data);
            final safePhotos = pexelsResponse.photos.where((photo) => _isSafe(photo)).toList();
            multiResults.add(safePhotos);
          }
        } catch (e) {
          debugPrint('Error fetching category $query: $e');
        }
      }));

      // Interleave the results so every row has different categories
      List<Photo> filteredPhotos = [];
      if (multiResults.isNotEmpty) {
        int maxItems = multiResults.map((e) => e.length).reduce((a, b) => a > b ? a : b);
        for (int i = 0; i < maxItems; i++) {
          for (var list in multiResults) {
            if (i < list.length) {
              filteredPhotos.add(list[i]);
            }
          }
        }
      }

      if (isRefresh) {
        latestPhotos.value = filteredPhotos;
      } else {
        final currentIds = latestPhotos.map((e) => e.id).toSet();
        final newPhotos = filteredPhotos
            .where((photo) => !currentIds.contains(photo.id))
            .toList();
        latestPhotos.addAll(newPhotos);
      }
      
      if (filteredPhotos.isNotEmpty) {
        _latestPage++;
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isLoadingLatest.value = false;
      isLoadingMore.value = false;
    }
  }


  bool _isSafe(Photo photo) {
    // Removed _isEnglish check to support international content
    
    final lowerPhotographer = photo.photographer.toLowerCase();
    final lowerUrl = photo.photographerUrl.toLowerCase();
    final lowerAlt = photo.alt.toLowerCase();
    final lowerSrc = photo.src.original.toLowerCase();
    
    final blackList = [
      'people', 'person', 'man', 'woman', 'model', 'human', 'face', 'portrait', 
      'selfie', 'girl', 'boy', 'adult'
    ];
    
    for (var word in blackList) {
      if (lowerPhotographer.contains(word) || 
          lowerUrl.contains(word) || 
          lowerAlt.contains(word) ||
          lowerSrc.contains(word)) {
        return false;
      }
    }
    
    return true;
  }

  bool _isSafeVideo(Video video) {
    // Removed character check for better compatibility
    
    final lowerUser = video.user.name.toLowerCase();
    final lowerUrl = video.url.toLowerCase();
    
    final blackList = [
      'people', 'person', 'man', 'woman', 'model', 'human', 'face', 'portrait', 
      'selfie', 'girl', 'boy', 'adult', 'teen', 'smile', 'look', 'standing', 'sitting'
    ];
    
    for (var word in blackList) {
      if (lowerUser.contains(word) || lowerUrl.contains(word)) {
        return false;
      }
    }
    
    return true;
  }

  Future<void> fetchCuratedWallpapers({bool isRefresh = true}) async {
    if (isLoadingMore.value || (isRefresh && isLoadingCurated.value)) return;

    try {
      if (isRefresh) {
        _curatedPage = 1;
        isLoadingCurated.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Pick 5 high-quality trending categories to interleave
      final trendingQueries = [
        'curated 8k wallpaper',
        'cinematic photography masterpiece',
        'high quality landscape 4k',
        'premium texture aesthetic',
        'world class architecture photography'
      ];
      
      List<List<Photo>> multiResults = [];
      
      await Future.wait(trendingQueries.map((query) async {
        try {
          final response = await http.get(
            Uri.parse(
                'https://api.pexels.com/v1/search?query=$query&per_page=12&page=$_curatedPage&orientation=portrait'),
            headers: {'Authorization': _apiKey},
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final pexelsResponse = PexelsResponse.fromJson(data);
            final safePhotos = pexelsResponse.photos.where((photo) => _isSafe(photo)).toList();
            multiResults.add(safePhotos);
          }
        } catch (e) {
          debugPrint('Error fetching trending $query: $e');
        }
      }));

      // Interleave results
      List<Photo> filteredPhotos = [];
      if (multiResults.isNotEmpty) {
        int maxItems = multiResults.map((e) => e.length).reduce((a, b) => a > b ? a : b);
        for (int i = 0; i < maxItems; i++) {
          for (var list in multiResults) {
            if (i < list.length) {
              filteredPhotos.add(list[i]);
            }
          }
        }
      }

      if (isRefresh) {
        curatedPhotos.value = filteredPhotos;
      } else {
        final currentIds = curatedPhotos.map((e) => e.id).toSet();
        final newPhotos = filteredPhotos
            .where((photo) => !currentIds.contains(photo.id))
            .toList();
        curatedPhotos.addAll(newPhotos);
      }
      
      if (filteredPhotos.isNotEmpty) {
        _curatedPage++;
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isLoadingCurated.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchSearchResults(String query, {bool isRefresh = true, String? color}) async {
    if (query.isEmpty) return;
    if (isLoadingMore.value || (isRefresh && isLoadingSearch.value)) return;

    _currentSearchQuery = query;

    try {
      if (isRefresh) {
        _searchPage = 1;
        isLoadingSearch.value = true;
      } else {
        isLoadingMore.value = true;
      }

      String refinedQuery = query;
      String url = 'https://api.pexels.com/v1/search?query=$refinedQuery&per_page=40&page=$_searchPage&orientation=portrait&locale=en-US';
      if (color != null && color.isNotEmpty) {
        url += '&color=$color';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final pexelsResponse = PexelsResponse.fromJson(data);

        final filteredPhotos = pexelsResponse.photos
            .where((photo) => _isSafe(photo))
            .toList();

        if (isRefresh) {
          searchPhotos.value = filteredPhotos;
        } else {
          final currentIds = searchPhotos.map((e) => e.id).toSet();
          final newPhotos = filteredPhotos
              .where((photo) => !currentIds.contains(photo.id))
              .toList();
          searchPhotos.addAll(newPhotos);
        }
        if (pexelsResponse.photos.isNotEmpty) {
          _searchPage++;
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      isLoadingSearch.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMoreSearch() {
    if (!isLoadingMore.value && _currentSearchQuery.isNotEmpty) {
      fetchSearchResults(_currentSearchQuery, isRefresh: false);
    }
  }

  Future<void> fetchLiveWallpapers({bool isRefresh = true}) async {
    if (isLoadingMore.value || (isRefresh && isLoadingVideos.value)) return;

    try {
      if (isRefresh) {
        _videoPage = 1;
        _videoQueries.shuffle(); // Shuffle for variety
        isLoadingVideos.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Pick 4 random video categories for diversity on a single load
      final randomVideoQueries = List<String>.from(_videoQueries)..shuffle();
      final selectedQueries = randomVideoQueries.take(4).toList();
      
      List<List<Video>> multiVideoResults = [];
      
      await Future.wait(selectedQueries.map((query) async {
        try {
          final encodedQuery = Uri.encodeComponent(query);
          final response = await http.get(
            Uri.parse('https://api.pexels.com/videos/search?query=$encodedQuery&per_page=10&page=$_videoPage'),
            headers: {'Authorization': _apiKey},
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final pexelsResponse = PexelsVideoResponse.fromJson(data);
            final safeVideos = pexelsResponse.videos.where((video) => _isSafeVideo(video)).toList();
            multiVideoResults.add(safeVideos);
          }
        } catch (e) {
          debugPrint('Error fetching video category $query: $e');
        }
      }));

      // Interleave video results
      List<Video> filteredVideos = [];
      if (multiVideoResults.isNotEmpty) {
        int maxItems = multiVideoResults.map((e) => e.length).reduce((a, b) => a > b ? a : b);
        for (int i = 0; i < maxItems; i++) {
          for (var list in multiVideoResults) {
            if (i < list.length) {
              filteredVideos.add(list[i]);
            }
          }
        }
      }

      // Fallback if interleaved fetch fails to get enough content
      if (filteredVideos.length < 5) {
        final fallbackResponse = await http.get(
          Uri.parse('https://api.pexels.com/videos/search?query=nature+scenery+abstract+loop&per_page=40&page=$_videoPage'),
          headers: {'Authorization': _apiKey},
        );
        if (fallbackResponse.statusCode == 200) {
          final data = json.decode(fallbackResponse.body);
          final pexelsResponse = PexelsVideoResponse.fromJson(data);
          filteredVideos = pexelsResponse.videos.where((video) => _isSafeVideo(video)).toList();
        }
      }

      if (isRefresh) {
        liveWallpapers.value = filteredVideos;
      } else {
        final currentIds = liveWallpapers.map((e) => e.id).toSet();
        final newVideos = filteredVideos
            .where((video) => !currentIds.contains(video.id))
            .toList();
        liveWallpapers.addAll(newVideos);
      }
      
      if (filteredVideos.isNotEmpty) {
        _videoPage++;
      }
    } catch (e) {
      debugPrint('Error fetching live wallpapers: $e');
    } finally {
      isLoadingVideos.value = false;
      isLoadingMore.value = false;
    }
  }
}
