import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:lottie/lottie.dart';
import 'package:luminawall/src/features/authentication/controller/favorites_controller.dart';
import 'package:luminawall/src/features/authentication/controller/settings_controller.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:luminawall/src/constants/animation_strings.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/constants/text_strings.dart';
import 'package:luminawall/src/features/authentication/screens/dashboard_screen/side_nav_bar/side_nav_bar.dart';

class WallpaperFullScreen extends StatefulWidget {
  const WallpaperFullScreen(this.link, {this.photo, this.heroTag, super.key});
  final String link;
  final Photo? photo;
  final String? heroTag;

  @override
  State<WallpaperFullScreen> createState() => _WallpaperFullScreenState();
}

class _WallpaperFullScreenState extends State<WallpaperFullScreen> {
  bool _showUI = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showUI = false;
        });
      }
    });
  }

  void _toggleUI() {
    setState(() {
      _showUI = !_showUI;
    });
    if (_showUI) {
      _startHideTimer();
    } else {
      _hideTimer?.cancel();
    }
  }

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final settingsController = Get.find<SettingsController>();
      final photo = widget.photo;
      final downloadUrl = photo != null
          ? settingsController.getDownloadUrl(
              original: photo.src.original,
              large2x: photo.src.large2x,
              large: photo.src.large,
              medium: photo.src.medium,
            )
          : widget.link;

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

  Future<void> _setwallpaper(BuildContext context, int location, Size size) async {
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
                  color: kJungleEmerald.withValues(alpha: 0.3), // Emerald Border
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kJungleDeepGreen.withValues(alpha: 0.2), // Deep Jungle shadow
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
      final photo = widget.photo;
      final downloadUrl = photo != null
          ? settingsController.getDownloadUrl(
              original: photo.src.original,
              large2x: photo.src.large2x,
              large: photo.src.large,
              medium: photo.src.medium,
            )
          : widget.link;
      final file = await DefaultCacheManager().getSingleFile(downloadUrl);
      
      progressState.value = wallpaperProcessing;
      
      final List<Directory>? externalDirs = await getExternalCacheDirectories();
      final String folderPath = externalDirs?.isNotEmpty == true ? externalDirs![0].path : (await getTemporaryDirectory()).path;
      
      // Use a unique filename every time to force the system to refresh
      final String fileName = 'wall_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final croppedFilePath = p.join(folderPath, fileName);

      // Clean up old wallpaper files in that directory first
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
        debugPrint("SetWallpaperFromFile failed, trying setWallpaper with file protocol...");
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

        // This forces the app to reset its state and refresh the home screen view
        Get.offAll(() => const SideNavBar()); 
    } catch (e) {
      if (context.mounted) {
        if (Navigator.canPop(context)) Navigator.pop(context);
        // Close any open dialogs/bottomsheets first
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
    
    // 4K UPSCALING: Increase limit to 4000px to support true 4K resolution screens (3840px)
    if (cropped.height > 4000) {
      cropped = img.copyResize(cropped, height: 4000, interpolation: img.Interpolation.linear);
    }

    await File(savePath).writeAsBytes(img.encodeJpg(cropped, quality: 85));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: _toggleUI,
        child: Stack(
          children: [
            RepaintBoundary(
              child: Hero(
                tag: widget.heroTag ?? widget.link,
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.link, // Main high-res image (Original)
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CachedNetworkImage(
                      imageUrl: widget.photo?.src.large2x ?? widget.link, // High-quality placeholder
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.black,
                        child: const Center(child: CircularProgressIndicator(color: kJungleEmerald)),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error, color: Colors.white)),
                  ),
                ),
              ),
            ),
            
            // Top Back Button
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              top: _showUI ? MediaQuery.of(context).padding.top + 15 : -100,
              left: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showUI ? 1.0 : 0.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Right Sidebar Buttons (Like, Share)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              right: _showUI ? 20 : -100,
              bottom: 210, // Perfectly aligned above the action buttons
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showUI ? 1.0 : 0.0,
                child: Column(
                  children: [
                    if (widget.photo != null)
                      Obx(() {
                        bool isFav = favoritesController.isFavorite(widget.photo!.id);
                        return _buildSidebarButton(
                          icon: isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.white,
                          onTap: () {
                            favoritesController.toggleFavorite(widget.photo!);
                            _startHideTimer();
                          },
                        );
                      }),
                    const SizedBox(height: 15),
                    _buildSidebarButton(
                      icon: Icons.share_rounded,
                      onTap: () {
                        // Logic for share can be added here
                        _startHideTimer();
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Buttons (Set, Download)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              bottom: _showUI ? MediaQuery.of(context).padding.bottom + 20 : -200,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showUI ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !_showUI,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                            foregroundColor: Theme.of(context).scaffoldBackgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 10,
                          ),
                          onPressed: () {
                            _showWallpaperMenu(context, size);
                            _startHideTimer(); // Reset timer on interaction
                          },
                          icon: const Icon(Icons.wallpaper),
                          label: const Text(
                            'Set Wallpaper',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            _downloadImage(context);
                            _startHideTimer(); // Reset timer on interaction
                          },
                          icon: const Icon(Icons.download_rounded),
                          label: const Text(
                            'Download to Gallery',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarButton({
    required IconData icon,
    VoidCallback? onTap,
    Color color = Colors.white,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: IconButton(
            icon: Icon(icon, color: color, size: 26),
            onPressed: onTap,
          ),
        ),
      ),
    );
  }

  void _showWallpaperMenu(BuildContext context, Size size) {
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
                      _setwallpaper(context, 1, size);
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
                      _setwallpaper(context, 2, size);
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
                      _setwallpaper(context, 3, size);
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
}
