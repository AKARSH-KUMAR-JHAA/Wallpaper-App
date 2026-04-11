import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/wallpaper_model.dart';

class WallpaperController extends GetxController {
  static WallpaperController get instance => Get.find();

  final _box = GetStorage();
  static const String _categoriesKey = 'user_home_categories';
  static const String _firstTimeKey = 'is_first_time_home';

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

  final RxList<String> userHomeCategories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserCategories();
    fetchLatestWallpapers();
    fetchCuratedWallpapers();
    fetchLiveWallpapers();
  }

  void _loadUserCategories() {
    final List<dynamic>? saved = _box.read(_categoriesKey);
    if (saved != null) {
      userHomeCategories.value = saved.cast<String>();
    } else {
      // Default to everything IF its NOT the first time
      if (!isFirstTime()) {
        userHomeCategories.value = List<String>.from(_masterCategories);
      }
    }
  }

  void saveUserCategories(List<String> categories) {
    userHomeCategories.value = categories;
    _box.write(_categoriesKey, categories);
    _box.write(_firstTimeKey, false); // Mark as no longer first time
    fetchLatestWallpapers(isRefresh: true);
  }

  bool isFirstTime() => _box.read(_firstTimeKey) ?? true;

  List<String> getMasterCategories() => _masterCategories;

  final List<String> _masterCategories = [
    'Nature', 'Abstract', 'Minimal', 'AMOLED', 'Space', 'City', 'Architecture', 
    'Anime', 'Gaming', 'Movies', 'Celebrities', 'Animals', 'Cute', 'Quotes', 
    'Typography', 'Cars', 'Bikes', 'Technology', 'Aesthetic', 'Dark', 'Neon', 
    '3D', 'Fantasy', 'Art', 'Illustrations', 'Gradient', 'Patterns', 'Flowers', 
    'Travel', 'Vintage'
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
    
    // Safety check for first-time personalization
    if (isFirstTime()) {
      if (userHomeCategories.isEmpty) {
        latestPhotos.clear();
        return;
      }
    } else {
      // If NOT first time but list is somehow empty (shouldn't happen), reload defaults
      if (userHomeCategories.isEmpty) {
        userHomeCategories.value = List<String>.from(_masterCategories);
      }
    }

    try {
      if (isRefresh) {
        _latestPage = 1;
        latestPhotos.clear();
        isLoadingLatest.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Pick random categories STRICTLY from user's choice list - broader sample (up to 10)
      final randomQueries = List<String>.from(userHomeCategories)..shuffle();
      final limit = userHomeCategories.length > 10 ? 10 : userHomeCategories.length;
      final selectedQueries = randomQueries.take(limit).map((q) => "$q wallpaper portrait -people -person").toList();
      
      List<List<Photo>> multiResults = [];
      
      // Fetch from up to 10 user-selected categories in parallel for a perfectly mixed grid
      await Future.wait(selectedQueries.map((query) async {
        try {
          // Task 1: Pexels API
          final pexelsUrl = 'https://api.pexels.com/v1/search?query=$query&per_page=15&page=$_latestPage&orientation=portrait&locale=en-US';
          final pexelsResponse = http.get(Uri.parse(pexelsUrl), headers: {'Authorization': _apiKey});

          // Task 2: Wallhaven API (Sanitize query for artistic/anime pool + Force Portrait)
          final wallQuery = query.replaceAll('wallpaper portrait -people -person', '').trim();
          final wallhavenUrl = 'https://wallhaven.cc/api/v1/search?q=$wallQuery&categories=110&purity=100&ratios=9x16,10x16,9x18&page=$_latestPage&sorting=toplist&topRange=1M';
          final wallhavenResponse = http.get(Uri.parse(wallhavenUrl));

          final results = await Future.wait([pexelsResponse, wallhavenResponse]);
          
          final List<Photo> combinedList = [];

          if (results[0].statusCode == 200) {
            final data = json.decode(results[0].body);
            final pResponse = PexelsResponse.fromJson(data);
            combinedList.addAll(pResponse.photos.where((photo) => _isSafe(photo)));
          }

          if (results[1].statusCode == 200) {
            final data = json.decode(results[1].body);
            final wResponse = WallhavenResponse.fromJson(data);
            combinedList.addAll(wResponse.photos.where((photo) => _isSafe(photo)));
          }

          if (combinedList.isNotEmpty) {
            multiResults.add(combinedList);
          }
        } catch (e) {
          debugPrint('Dual-API Category Fetch Error: $e');
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
      'selfie', 'girl', 'boy', 'adult', 'cosplay', 'costume'
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
        // Randomize the starting page for better discovery on refresh
        _curatedPage = Random().nextInt(30) + 1; // 1 to 30
        isLoadingCurated.value = true;
      } else {
        isLoadingMore.value = true;
      }

      // Randomly pick categories from master list for curated trending variety
      final randomQueries = List<String>.from(_masterCategories)..shuffle();
      final selectedQueries = randomQueries.take(8).map((q) => "$q cinematic 8k wallpaper -people -person").toList();
      
      List<List<Photo>> multiResults = [];
      
      // Dual-API fetch for every curated category
      await Future.wait(selectedQueries.take(5).map((query) async {
        try {
          // Task 1: Pexels API
          final pexelsUrl = 'https://api.pexels.com/v1/search?query=$query&per_page=12&page=$_curatedPage&orientation=portrait';
          final pexelsResponse = http.get(Uri.parse(pexelsUrl), headers: {'Authorization': _apiKey});

          // Task 2: Wallhaven API (mapping current query to artistic pool + Force Portrait)
          final wallQuery = query.replaceAll('cinematic 8k wallpaper -people -person', '').trim();
          final wallhavenUrl = 'https://wallhaven.cc/api/v1/search?q=$wallQuery&categories=110&purity=100&ratios=9x16,10x16,9x18&page=$_curatedPage&sorting=toplist&topRange=1M';
          final wallhavenResponse = http.get(Uri.parse(wallhavenUrl));

          final results = await Future.wait([pexelsResponse, wallhavenResponse]);
          
          final List<Photo> combinedList = [];

          if (results[0].statusCode == 200) {
            final data = json.decode(results[0].body);
            final pResponse = PexelsResponse.fromJson(data);
            combinedList.addAll(pResponse.photos.where((photo) => _isSafe(photo)));
          }

          if (results[1].statusCode == 200) {
            final data = json.decode(results[1].body);
            final wResponse = WallhavenResponse.fromJson(data);
            combinedList.addAll(wResponse.photos.where((photo) => _isSafe(photo)));
          }

          if (combinedList.isNotEmpty) {
            multiResults.add(combinedList);
          }
        } catch (e) {
          debugPrint('Dual-API Trending Fetch Error: $e');
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

      String refinedQuery = "$query -people -person -human -man -woman";
      String url = 'https://api.pexels.com/v1/search?query=${Uri.encodeComponent(refinedQuery)}&per_page=40&page=$_searchPage&orientation=portrait&locale=en-US';
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
