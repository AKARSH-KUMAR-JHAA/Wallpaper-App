import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/common_widget/standard_header.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/widgets/premium_wallpaper_card.dart';

import '../../../../../constants/colors_strings.dart';
import '../../../controller/wallpaper_controller.dart';


class TrendingTab extends StatefulWidget {
  const TrendingTab({super.key});

  @override
  State<TrendingTab> createState() => _TrendingTabState();
}

class _TrendingTabState extends State<TrendingTab> {
  final ScrollController _scrollController = ScrollController();
  final pexelsController = Get.find<WallpaperController>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        pexelsController.fetchCuratedWallpapers(isRefresh: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kJungleMossDark,
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

          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 10),
              const StandardHeader(
                title: "Trending",
                subtitle: "High Quality Wallpapers",
              ),
              Expanded(
                child: RefreshIndicator(
                  color: kJungleEmerald,
                  backgroundColor: kJungleMossDark,
                  onRefresh: () async =>
                      await pexelsController.fetchCuratedWallpapers(),
                  child: Obx(() {
                    if (pexelsController.isLoadingCurated.value &&
                        pexelsController.curatedPhotos.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: kJungleEmerald));
                    }

                    if (pexelsController.curatedPhotos.isEmpty) {
                      return LayoutBuilder(
                        builder: (context, constraints) => SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.trending_up_rounded, size: 60, color: kJungleEmerald.withValues(alpha: 0.3)),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No Trending Wallpapers Found\nPull down to try again",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kJungleCream.withValues(alpha: 0.7)),
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
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.55,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: pexelsController.curatedPhotos.length,
                              itemBuilder: (context, i) {
                                var photo = pexelsController.curatedPhotos[i];
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
