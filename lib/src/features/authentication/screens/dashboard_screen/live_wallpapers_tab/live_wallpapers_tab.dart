import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/features/authentication/controller/wallpaper_controller.dart';
import 'package:luminawall/src/common_widget/standard_header.dart';
import '../../../../../constants/colors_strings.dart';
import '../widgets/premium_live_wallpaper_card.dart';

class LiveWallpapersTab extends StatefulWidget {
  const LiveWallpapersTab({super.key});

  @override
  State<LiveWallpapersTab> createState() => _LiveWallpapersTabState();
}

class _LiveWallpapersTabState extends State<LiveWallpapersTab> {
  final ScrollController _scrollController = ScrollController();
  final pexelsController = Get.find<WallpaperController>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        pexelsController.fetchLiveWallpapers(isRefresh: false);
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
                title: "Modern Live",
                subtitle: "High-Quality Abstract Designs",
              ),
              Expanded(
                child: RefreshIndicator(
                  color: kJungleEmerald,
                  backgroundColor: kJungleMossDark,
                  onRefresh: () async =>
                      await pexelsController.fetchLiveWallpapers(),
                  child: Obx(() {
                    // If videos are empty and we are loading, show a full screen loader
                    if (pexelsController.isLoadingVideos.value &&
                        pexelsController.liveWallpapers.isEmpty) {
                      return const Center(child: CircularProgressIndicator(color: kJungleEmerald));
                    }

                    return CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      slivers: [

                        // Cinematic Header
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                            child: Text(
                              "CINEMATIC MOTION DESIGNS",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: kJungleCream.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ),

                        // Empty State for Grid
                        if (pexelsController.liveWallpapers.isEmpty && !pexelsController.isLoadingVideos.value)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.video_library_outlined, size: 60, color: kJungleEmerald.withValues(alpha: 0.2)),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No Designs Found in your Region\nPull down to refresh",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: kJungleCream.withValues(alpha: 0.5)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Grid for Abstract videos
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.55,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                var video = pexelsController.liveWallpapers[i];
                                return PremiumLiveWallpaperCard(video: video);
                              },
                              childCount: pexelsController.liveWallpapers.length,
                            ),
                          ),
                        ),
                        
                        // Loading More Indicator
                        if (pexelsController.isLoadingMore.value || (pexelsController.isLoadingVideos.value && pexelsController.liveWallpapers.isNotEmpty))
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(child: CircularProgressIndicator(color: kJungleEmerald)),
                            ),
                          ),
                        
                        // Bottom padding
                        const SliverToBoxAdapter(child: SizedBox(height: 80)),
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
