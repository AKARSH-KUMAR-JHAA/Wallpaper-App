import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/common_widget/standard_header.dart';
import 'package:luminawall/src/features/authentication/controller/wallpaper_controller.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import '../../../../../constants/colors_strings.dart';
import '../widgets/premium_wallpaper_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ScrollController _scrollController = ScrollController();
  final pexelsController = Get.put(WallpaperController());

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        pexelsController.fetchLatestWallpapers(isRefresh: false);
      }
    });

    // Show selection on first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pexelsController.isFirstTime()) {
        _showInterestsSelection();
      }
    });
  }

  void _showInterestsSelection() {
    final List<String> tempSelected = [];
    final allCats = pexelsController.getMasterCategories();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: isDark ? kJungleDeepGreen : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 25),
              Text("Select Your Vibe", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : kJungleDeepGreen)),
              const SizedBox(height: 8),
              Text("Choose at least 3 categories for your Home feed", style: TextStyle(color: isDark ? Colors.white60 : Colors.black54)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: allCats.map((cat) {
                      final isSelected = tempSelected.contains(cat);
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            if (selected) {
                              tempSelected.add(cat);
                            } else {
                              tempSelected.remove(cat);
                            }
                          });
                        },
                        selectedColor: kJungleEmerald,
                        labelStyle: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87)),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tempSelected.length >= 3 ? kJungleEmerald : Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: tempSelected.length >= 3 ? () {
                      pexelsController.saveUserCategories(tempSelected);
                      Get.back();
                    } : null,
                    child: const Text("Curate My Feed", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      enableDrag: false,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Theme Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark ? [
                    kJungleDeepGreen,
                    kJungleMossDark,
                  ] : [
                    Colors.white,
                    kJungleCream,
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              const StandardHeader(
                title: latestTitle,
                subtitle: latestSubtitle,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: kJungleEmerald,
                  backgroundColor: isDark ? kJungleMossDark : Colors.white,
                  onRefresh: () async =>
                      await pexelsController.fetchLatestWallpapers(),
                  child: Obx(() {
                    if (pexelsController.isLoadingLatest.value &&
                        pexelsController.latestPhotos.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: kJungleEmerald),
                      );
                    }

                    if (pexelsController.latestPhotos.isEmpty) {
                      return LayoutBuilder(
                        builder: (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.nature_people_rounded, size: 60, color: kJungleEmerald.withValues(alpha: 0.3)),
                                  const SizedBox(height: 16),
                                  Text(
                                    noWallpapersFound,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: isDark ? kJungleCream.withValues(alpha: 0.7) : kJungleMossDark.withValues(alpha: 0.7)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GridView.builder(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.55,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: pexelsController.latestPhotos.length,
                              itemBuilder: (context, i) {
                                var photo = pexelsController.latestPhotos[i];
                                var imageUrl = photo.src.large;
                                return PremiumWallpaperCard(
                                  photo: photo,
                                  heroTag: imageUrl,
                                );
                              },
                            ),
                          ),
                        ),
                        if (pexelsController.isLoadingMore.value)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(color: kJungleEmerald),
                          ),
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
