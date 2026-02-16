import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/controller/wallpaper_controller.dart';
import 'package:luminawall/src/features/authentication/controller/wallhaven_controller.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/common_widget/standard_header.dart';
import '../widgets/premium_wallpaper_card.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  State<CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final pexelsController = Get.find<WallpaperController>();
  final wallhavenController = Get.find<WallhavenController>();
  final TextEditingController searchController = TextEditingController();
  String? selectedColor;

  final List<String> categories = [
    'Abstract', 'Nature', 'Landscapes', 'Minimalist', 'AMOLED', '3D', 'Space', 'Cityscapes', 'Animals', 'Anime', 'Pop Culture'
  ];

  final List<Map<String, dynamic>> colors = [
    {'name': 'Red', 'color': Colors.red},
    {'name': 'Orange', 'color': Colors.orange},
    {'name': 'Yellow', 'color': Colors.yellow},
    {'name': 'Green', 'color': Colors.green},
    {'name': 'Blue', 'color': Colors.blue},
    {'name': 'Violet', 'color': Colors.deepPurple},
    {'name': 'Pink', 'color': Colors.pink},
    {'name': 'Black', 'color': Colors.black},
    {'name': 'White', 'color': Colors.white},
  ];

  @override
  void initState() {
    super.initState();
    categories.shuffle(); // Randomize categories on init
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_isWallhavenSearch(searchController.text)) {
          wallhavenController.loadMore();
        } else {
          pexelsController.loadMoreSearch();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  String? selectedCategory;

  bool _isWallhavenSearch(String query) {
    final lowerQuery = query.toLowerCase();
    return lowerQuery.contains('anime') || 
           lowerQuery.contains('superhero') || 
           selectedCategory == 'Anime' || 
           selectedCategory == 'Superheroes';
  }

  void _onSearch(String query) {
    setState(() {
      selectedCategory = categories.contains(query) ? query : null;
    });
    
    // Always fetch from both for better results
    pexelsController.fetchSearchResults(query, color: selectedColor);
    wallhavenController.fetchWallhavenWallpapers(query);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kJungleMossDark,
      endDrawer: _buildFilterDrawer(context, true),
      body: Stack(
        children: [
          // Theme Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              const StandardHeader(
                title: "Explore",
                subtitle: "High Quality Wallpapers",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    // Premium Floating Search Bar
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: kJungleMossDark.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: kJungleEmerald.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onSubmitted: _onSearch,
                          autocorrect: false,
                          enableSuggestions: false,
                          style: const TextStyle(
                            color: kJungleCream,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search for vibes...",
                            hintStyle: TextStyle(
                              color: kJungleCream.withValues(alpha: 0.4),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 15, right: 10),
                              child: Icon(Icons.search_rounded, color: kJungleEmerald, size: 28),
                            ),
                            suffixIcon: searchController.text.isNotEmpty ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                icon: const Icon(Icons.close_rounded, size: 22, color: kJungleCream),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    selectedCategory = null;
                                    pexelsController.searchPhotos.clear();
                                    wallhavenController.wallhavenPhotos.clear();
                                  });
                                },
                              ),
                            ) : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Filter Button
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kJungleEmerald, kJungleGreen],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kJungleEmerald.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  final isLoading = pexelsController.isLoadingSearch.value && wallhavenController.isLoading.value;
                  
                  // Combine results - intelligently interleave for variety
                  final List<Photo> combinedPhotos = [];
                  final pexelsPhotos = pexelsController.searchPhotos;
                  final wallhavenPhotos = wallhavenController.wallhavenPhotos;
                  final Set<String> addedIds = {};
                  
                  int maxLength = pexelsPhotos.length > wallhavenPhotos.length 
                      ? pexelsPhotos.length 
                      : wallhavenPhotos.length;

                  for (int i = 0; i < maxLength; i++) {
                    if (i < pexelsPhotos.length) {
                      if (!addedIds.contains(pexelsPhotos[i].id)) {
                        combinedPhotos.add(pexelsPhotos[i]);
                        addedIds.add(pexelsPhotos[i].id);
                      }
                    }
                    if (i < wallhavenPhotos.length) {
                      if (!addedIds.contains(wallhavenPhotos[i].id)) {
                        combinedPhotos.add(wallhavenPhotos[i]);
                        addedIds.add(wallhavenPhotos[i].id);
                      }
                    }
                  }

                  if (isLoading && combinedPhotos.isEmpty) {
                    return const Center(child: CircularProgressIndicator(color: kJungleEmerald));
                  }

                  if (combinedPhotos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_search, size: 80, color: kJungleEmerald.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          Text(
                            "Find your perfect vibe",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: kJungleCream),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Explore millions of high-quality wallpapers",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                  color: kJungleCream.withValues(alpha: 0.5),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          color: kJungleEmerald,
                          backgroundColor: kJungleMossDark,
                          onRefresh: () async {
                            _onSearch(searchController.text);
                          },
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: combinedPhotos.length,
                            itemBuilder: (context, idx) {
                              var photo = combinedPhotos[idx];
                              var imageUrl = photo.src.large;
                              
                              return PremiumWallpaperCard(
                                photo: photo, 
                                heroTag: imageUrl
                              );
                            },
                          ),
                        ),
                      ),
                      if (pexelsController.isLoadingMore.value || wallhavenController.isLoadingMore.value)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: CircularProgressIndicator(color: kJungleEmerald),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDrawer(BuildContext context, bool isDark) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filters",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildDrawerHeader("CATEGORIES", isDark),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((cat) {
                      bool isSelected = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            searchController.text = cat;
                            _onSearch(cat);
                            Get.back();
                          }
                        },
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        selectedColor: Theme.of(context).primaryColor,
                        backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  _buildDrawerHeader("PALETTE", isDark),
                  const SizedBox(height: 15),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                    ),
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      bool isSelected = selectedColor == colors[index]['name'].toString().toLowerCase();
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = isSelected ? null : colors[index]['name'].toString().toLowerCase();
                          });
                          if (searchController.text.isNotEmpty) {
                            _onSearch(searchController.text);
                          }
                          Get.back();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: colors[index]['color'],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Theme.of(context).primaryColor : Colors.white.withValues(alpha: 0.2),
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: colors[index]['color'].withValues(alpha: 0.4),
                                  blurRadius: 8,
                                )
                            ],
                          ),
                          child: isSelected ? Icon(
                            Icons.check_rounded, 
                            size: 16, 
                            color: (colors[index]['name'] == 'White' || colors[index]['name'] == 'Yellow') ? Colors.black : Colors.white
                          ) : null,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  // Reset Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          selectedCategory = null;
                          selectedColor = null;
                        });
                        Get.back();
                      },
                      child: const Text("Reset Filters"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }
}
