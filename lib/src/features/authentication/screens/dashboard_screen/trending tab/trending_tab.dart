import 'dart:io';
import 'dart:ui';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:gal/gal.dart';
import 'package:lottie/lottie.dart';
import 'package:luminawall/src/constants/animation_strings.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/features/authentication/controller/favorites_controller.dart';
import 'package:luminawall/src/features/authentication/controller/settings_controller.dart';
import 'package:luminawall/src/features/authentication/controller/sidebar_controller.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';
import 'package:luminawall/src/features/authentication/screens/wallpaper_full_screen/wallpaper_full_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../../../constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/controller/trending_controller.dart';
import 'package:luminawall/src/features/authentication/controller/wallhaven_controller.dart';
import 'package:luminawall/src/features/authentication/controller/wallpaper_controller.dart';
import 'package:luminawall/src/features/authentication/controller/rating_controller.dart';


class TrendingTab extends StatefulWidget {
  const TrendingTab({super.key});

  @override
  State<TrendingTab> createState() => _TrendingTabState();
}

class _TrendingTabState extends State<TrendingTab> {
  final pexelsController = Get.find<WallpaperController>();
  final trendingController = Get.find<TrendingController>();
  final favoritesController = Get.find<FavoritesController>();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Refresh content whenever the tab is initialized/switched to
    trendingController.fetchGlobalTrending();
    pexelsController.fetchCuratedWallpapers(isRefresh: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _downloadImage(BuildContext context, Photo photo) async {
    try {
      final settingsController = Get.find<SettingsController>();
      final downloadUrl = settingsController.getDownloadUrl(
              original: photo.src.original,
              large2x: photo.src.large2x,
              large: photo.src.large,
              medium: photo.src.medium,
            );

      final file = await DefaultCacheManager().getSingleFile(downloadUrl);
      await Gal.putImage(file.path);

      if (context.mounted) {
        Fluttertoast.showToast(
          msg: wallpaperSaved,
          backgroundColor: kJungleForestGreen,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = wallpaperError;
        if (e is GalException) {
          errorMessage = e.type.name;
        }
        Fluttertoast.showToast(
          msg: "Error: $errorMessage",
          backgroundColor: Colors.red.shade900,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        // Build a unified list: Top Community Likes first, then Curated
        final List<Photo> communityPhotos = trendingController.topPhotos;
        final List<Photo> curatedPhotos = pexelsController.curatedPhotos;

        // Use a set of IDs for deduplication
        final Set<String> seenIds = communityPhotos.map((p) => p.id.toString()).toSet();
        final List<Photo> unifiedPhotoList = [
          ...communityPhotos,
          ...curatedPhotos.where((p) => !seenIds.contains(p.id.toString())),
        ];

        if (pexelsController.isLoadingCurated.value && unifiedPhotoList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: kJungleEmerald));
        }

        if (unifiedPhotoList.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up, color: kJungleEmerald, size: 50),
                const SizedBox(height: 10),
                Text("Your discovery feed is loading", style: TextStyle(color: kJungleCream)),
                TextButton(
                  onPressed: () {
                    trendingController.fetchGlobalTrending();
                    pexelsController.fetchCuratedWallpapers();
                  },
                  child: Text("Refresh", style: TextStyle(color: kJungleEmerald)),
                )
              ],
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              color: kJungleEmerald,
              onRefresh: () async {
                await trendingController.fetchGlobalTrending();
                await pexelsController.fetchCuratedWallpapers(isRefresh: true);
              },
              child: PageView.builder(
                scrollDirection: Axis.vertical,
                controller: _pageController,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: unifiedPhotoList.length,
                onPageChanged: (index) {
                  // Infinite scroll trigger
                  if (index >= unifiedPhotoList.length - 3) {
                    pexelsController.fetchCuratedWallpapers(isRefresh: false);
                  }
                },
                itemBuilder: (context, index) {
                  final photo = unifiedPhotoList[index];
                  // Determine if this photo is one of the top community picks
                  final isCommunityTop = index < communityPhotos.length;
                  return _buildWallpaperPage(photo, isCommunityTop);
                },
              ),
            ),
            
            // Floating Menu Button for Sidebar
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 15,
              child: GestureDetector(
                onTap: () {
                  try {
                    Get.find<MyDrawerController>().toggleDrawer();
                  } catch (e) {
                    debugPrint("Drawer Controller Error: $e");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 1),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1),
                    ],
                  ),
                  child: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildWallpaperPage(Photo photo, bool isCommunity) {
    final imageUrl = photo.src.large2x;
    final photographer = photo.photographer;
    final alt = photo.alt;
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Full screen Image
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              final settings = Get.find<SettingsController>();
              final fullResLink = settings.getDownloadUrl(
                original: photo.src.original,
                large2x: photo.src.large2x,
                large: photo.src.large,
                medium: photo.src.medium,
              );
              Get.to(() => WallpaperFullScreen(fullResLink, photo: photo, heroTag: photo.id));
            },
            child: Hero(
              tag: photo.id,
              child: CachedNetworkImage(
                imageUrl: photo.src.portrait.isNotEmpty ? photo.src.portrait : photo.src.large2x,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.black12,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: kJungleEmerald, strokeWidth: 2),
                        const SizedBox(height: 10),
                        Text("Loading HD...", style: TextStyle(color: kJungleCream.withValues(alpha: 0.5), fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        ),

        // Bottom Gradient Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Side Action Buttons
        Positioned(
          right: 15,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                icon: Icons.wallpaper_rounded,
                label: "Set",
                onTap: () => _showWallpaperMenu(context, size, photo),
              ),
              const SizedBox(height: 25),
              Obx(() {
                final isFav = favoritesController.isFavorite(photo.id);
                final likes = trendingController.getLikes(photo.id.toString());
                return _buildActionButton(
                  icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: "LIKE",
                  count: likes > 0 ? likes.toString() : null,
                  color: isFav ? Colors.redAccent : Colors.white,
                  onTap: () => favoritesController.toggleFavorite(photo),
                );
              }),
              const SizedBox(height: 25),
              _buildActionButton(
                icon: Icons.download_rounded,
                label: "Save",
                onTap: () => _downloadImage(context, photo),
              ),
              const SizedBox(height: 25),
              _buildActionButton(
                icon: Icons.info_outline_rounded,
                label: "Info",
                onTap: () {
                  _showInfoBottomSheet(photographer, alt);
                },
              ),
            ],
          ),
        ),

        // Bottom Details
        Positioned(
          bottom: 40,
          left: 20,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCommunity ? Colors.amber.withValues(alpha: 0.9) : kJungleEmerald.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isCommunity ? "👑 COMMUNITY TOP" : "TRENDING",
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                photographer.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                alt.isEmpty ? "Premium Wallpaper - LuminaWall Exclusive" : alt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: kJungleCream.withValues(alpha: 0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Swipe Indicator at the top (optional visual cue)
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_vert_rounded, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "SWIPE UP FOR MORE",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon, 
    required String label, 
    required VoidCallback onTap, 
    Color color = Colors.white,
    String? count,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4), // Slightly darker for depth
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, 
                  blurRadius: 12, 
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                if (count != null && count != "0") ...[
                  const SizedBox(height: 2),
                  Text(
                    count,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoBottomSheet(String photographer, String alt) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: kJungleMossDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_rounded, color: kJungleEmerald),
                const SizedBox(width: 10),
                Text(
                  "WALLPAPER INFO",
                  style: TextStyle(
                    color: kJungleCream,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const Divider(height: 30, color: Colors.white12),
            _buildInfoRow("Photographer", photographer),
            const SizedBox(height: 15),
            _buildInfoRow("Description", alt.isEmpty ? "No description available" : alt),
            const SizedBox(height: 15),
            _buildInfoRow("Resolution", "High Definition 4K"),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kJungleEmerald,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("CLOSE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: kJungleEmerald.withValues(alpha: 0.7),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: kJungleCream,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // --- WALLPAPER SETTING LOGIC ---

  void _showWallpaperMenu(BuildContext context, Size size, Photo photo) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
          decoration: BoxDecoration(
            color: isDark ? kJungleMossDark : Colors.white, 
            borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
            border: Border.all(
              color: kJungleEmerald.withValues(alpha: 0.2), 
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 10,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: kJungleEmerald.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                wallpaperSetTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: isDark ? kJungleCream : kJungleGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                wallpaperSetSubtitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.green.shade200 : Colors.green.shade800,
                ),
              ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: _buildOptionCard(
                    context: context,
                    icon: Icons.home_rounded,
                    title: wallpaperHome,
                    onTap: () {
                      Navigator.of(context).pop();
                      _setwallpaper(context, 1, size, photo);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildOptionCard(
                    context: context,
                    icon: Icons.lock_rounded,
                    title: wallpaperLock,
                    onTap: () {
                      Navigator.of(context).pop();
                      _setwallpaper(context, 2, size, photo);
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildOptionCard(
                    context: context,
                    icon: Icons.phonelink_setup_rounded,
                    title: wallpaperBoth,
                    onTap: () {
                      Navigator.of(context).pop();
                      _setwallpaper(context, 3, size, photo);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
              width: 1.5,
            ),
            color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setwallpaper(BuildContext context, int location, Size size, Photo photo) async {
    final RxString progressState = wallpaperDownloading.obs;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.black.withValues(alpha: 0.8) 
                  : Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: kJungleEmerald.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kJungleDeepGreen.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  )
                ],
              ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset(
                    loginAni3,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Text(
                  progressState.value,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                )),
                const SizedBox(height: 10),
                const Text(
                  'Please wait a moment',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );

    try {
      final settingsController = Get.find<SettingsController>();
      final downloadUrl = settingsController.getDownloadUrl(
              original: photo.src.original,
              large2x: photo.src.large2x,
              large: photo.src.large,
              medium: photo.src.medium,
            );
      final file = await DefaultCacheManager().getSingleFile(downloadUrl);
      
      progressState.value = wallpaperProcessing;
      
      final List<Directory>? externalDirs = await getExternalCacheDirectories();
      final String folderPath = externalDirs?.isNotEmpty == true ? externalDirs![0].path : (await getTemporaryDirectory()).path;
      
      final String fileName = 'wall_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final croppedFilePath = p.join(folderPath, fileName);

      try {
        final dir = Directory(folderPath);
        final files = dir.listSync();
        for (var f in files) {
          if (f is File && f.path.contains('wall_')) {
            await f.delete();
          }
        }
      } catch (_) {}

      await compute(_processImageInIsolate, {
        'imagePath': file.path,
        'savePath': croppedFilePath,
        'screenWidth': size.width,
        'screenHeight': size.height,
      });

      progressState.value = wallpaperApplyingToScreen;

      int wallLocation;
      if (location == 1) {
        wallLocation = AsyncWallpaper.HOME_SCREEN;
      } else if (location == 2) {
        wallLocation = AsyncWallpaper.LOCK_SCREEN;
      } else {
        wallLocation = AsyncWallpaper.BOTH_SCREENS;
      }

      dynamic result = await AsyncWallpaper.setWallpaperFromFile(
        filePath: croppedFilePath,
        wallpaperLocation: wallLocation,
        goToHome: false,
      );

      bool isSuccess = (result == true) || (result.toString() == "Wallpaper set");
      
      if (!isSuccess) {
        result = await AsyncWallpaper.setWallpaper(
          url: "file://$croppedFilePath",
          wallpaperLocation: wallLocation,
          goToHome: false,
        );
        isSuccess = (result == true) || (result.toString() == "Wallpaper set");
      }

        progressState.value = wallpaperAlmostDone;
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!context.mounted) return;
        Navigator.pop(context); // Close loading
        
        Fluttertoast.showToast(
          msg: wallpaperAppliedSuccess,
          backgroundColor: kJungleGreen,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
    } catch (e) {
      if (context.mounted) {
        if (Navigator.canPop(context)) Navigator.pop(context);
        if (Get.isBottomSheetOpen == true || Get.isDialogOpen == true) {
          if (Get.context != null) Navigator.pop(Get.context!);
        }
        Fluttertoast.showToast(
          msg: "Error Setting Wallpaper: $e",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }
  }

  static Future<void> _processImageInIsolate(Map<String, dynamic> params) async {
    final String imagePath = params['imagePath'];
    final String savePath = params['savePath'];
    final double screenWidth = params['screenWidth'];
    final double screenHeight = params['screenHeight'];

    final bytes = await File(imagePath).readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Decode failed");

    double screenAspect = screenWidth / screenHeight;
    double imageAspect = image.width / image.height;
    int cropX = 0, cropY = 0, cropW = image.width, cropH = image.height;

    if (imageAspect > screenAspect) {
      cropW = (image.height * screenAspect).toInt();
      cropX = (image.width - cropW) ~/ 2;
    } else {
      cropH = (image.width / screenAspect).toInt();
      cropY = (image.height - cropH) ~/ 2;
    }

    img.Image cropped = img.copyCrop(image, x: cropX, y: cropY, width: cropW, height: cropH);
    
    if (cropped.height > 2400) {
      cropped = img.copyResize(cropped, height: 2400, interpolation: img.Interpolation.linear);
    }

    await File(savePath).writeAsBytes(img.encodeJpg(cropped, quality: 85));
  }
}
