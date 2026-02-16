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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                title: latestTitle,
                subtitle: latestSubtitle,
              ),
              Expanded(
                child: RefreshIndicator(
                  color: kJungleEmerald,
                  backgroundColor: kJungleMossDark,
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
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: size.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.nature_people_rounded, size: 60, color: kJungleEmerald.withValues(alpha: 0.3)),
                                const SizedBox(height: 16),
                                Text(
                                  noWallpapersFound,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: kJungleCream.withValues(alpha: 0.7)),
                                ),
                              ],
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
