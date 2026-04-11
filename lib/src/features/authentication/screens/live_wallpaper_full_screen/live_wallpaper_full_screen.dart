import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

import '../../controller/favorites_controller.dart';

class LiveWallpaperFullScreen extends StatefulWidget {
  final Video video;
  const LiveWallpaperFullScreen({required this.video, super.key});

  @override
  State<LiveWallpaperFullScreen> createState() => _LiveWallpaperFullScreenState();
}

class _LiveWallpaperFullScreenState extends State<LiveWallpaperFullScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isSetting = false;
  bool _showUI = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _startHideTimer();
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

  Future<void> _initializePlayer() async {
    try {
      final videoUrl = _getBestVideoUrl();
      if (videoUrl.isEmpty) throw Exception("Video URL is empty");

      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _controller = controller;
      
      await controller.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        controller.setLooping(true);
        controller.play();
        
        controller.addListener(() {
          if (mounted && _isInitialized && !controller.value.isPlaying && 
              controller.value.position >= controller.value.duration) {
            controller.seekTo(Duration.zero);
            controller.play();
          }
        });
      }
    } catch (e) {
      debugPrint("Video Init Error: $e");
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Failed to load video preview: $e',
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      }
    }
  }

  String _getBestVideoUrl() {
    try {
      // 1. Try to find the highest resolution portrait video (HD or higher)
      var portraitFiles = widget.video.videoFiles.where((file) => file.width < file.height).toList();
      if (portraitFiles.isNotEmpty) {
        portraitFiles.sort((a, b) => (b.width * b.height).compareTo(a.width * a.height));
        if (portraitFiles.first.width >= 720) {
          return portraitFiles.first.link;
        }
      }

      // 2. If no high-res portrait, find the absolute highest resolution file available
      var allFiles = List<VideoFile>.from(widget.video.videoFiles);
      if (allFiles.isEmpty) return widget.video.url;
      
      allFiles.sort((a, b) => (b.width * b.height).compareTo(a.width * a.height));
      return allFiles.first.link;
    } catch (e) {
      return widget.video.url;
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _downloadVideo() async {
    try {
      final videoUrl = _getBestVideoUrl();
      final file = await DefaultCacheManager().getSingleFile(videoUrl);
      await Gal.putVideo(file.path);

      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Live Wallpaper Saved to Gallery',
          backgroundColor: kJungleEmerald,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'Error: ${e.toString()}',
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
        );
      }
    }
  }

  Future<void> _setLiveWallpaper() async {
    if (Platform.isIOS) {
      Fluttertoast.showToast(
        msg: "iOS does not support setting live wallpapers directly.",
        backgroundColor: Colors.orange.withValues(alpha: 0.9),
        textColor: Colors.white,
      );
      return;
    }

    setState(() => _isSetting = true);
    try {
      final videoUrl = _getBestVideoUrl();
      final file = await DefaultCacheManager().getSingleFile(videoUrl);
      
      final appDir = await getApplicationDocumentsDirectory();
      final targetFile = File('${appDir.path}/live_wallpaper.mp4');
      
      await file.copy(targetFile.path);
      
      if (!await targetFile.exists()) {
        throw Exception("Video file could not be prepared");
      }

      bool result = await AsyncWallpaper.setLiveWallpaper(
        filePath: targetFile.path,
      );

      if (mounted) {
        if (result) {
          Fluttertoast.showToast(
            msg: "Live wallpaper setup started",
            backgroundColor: kJungleEmerald,
            textColor: Colors.white,
          );
        } else {
          throw Exception("Could not initialize wallpaper service");
        }
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Failed to set live wallpaper: $e",
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
        );
      }
      debugPrint("Live Wallpaper Error: $e");
    } finally {
      if (mounted) setState(() => _isSetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTap: _toggleUI,
        child: Stack(
          children: [
            // Video Preview with Hero Thumbnail while loading
            Positioned.fill(
              child: Hero(
                tag: widget.video.image,
                child: Stack(
                  children: [
                    // Show thumbnail ONLY when video isn't ready
                    if (!_isInitialized)
                      Positioned.fill(
                        child: Image.network(
                          widget.video.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    // Optimized Video Player layer
                    if (_isInitialized && _controller != null)
                      Positioned.fill(
                        child: RepaintBoundary(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller!.value.size.width,
                              height: _controller!.value.size.height,
                              child: VideoPlayer(_controller!),
                            ),
                          ),
                        ),
                      ),
                    // Show loading indicator if not initialized
                    if (!_isInitialized)
                      const Center(child: CircularProgressIndicator(color: Colors.white)),
                  ],
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
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Right Sidebar (Like & Share)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              right: _showUI ? 20 : -100,
              bottom: 210, // Matching static wallpaper placement
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showUI ? 1.0 : 0.0,
                child: Column(
                  children: [
                    // Like Button
                    Obx(() {
                      final favoritesController = Get.find<FavoritesController>();
                      final isFav = favoritesController.isFavoriteLive(widget.video.id);
                      return _buildSidebarButton(
                        icon: isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? Colors.redAccent : Colors.white,
                        onTap: () {
                          favoritesController.toggleFavoriteLive(widget.video);
                          _startHideTimer();
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                    // Share Button
                    _buildSidebarButton(
                      icon: Icons.share_rounded,
                      onTap: () {
                        // Share logic
                        _startHideTimer();
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
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
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _isSetting ? null : () {
                            _setLiveWallpaper();
                            _startHideTimer(); // Reset timer on interaction
                          },
                          icon: _isSetting 
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.wallpaper),
                          label: Text(
                            _isSetting ? 'Applying...' : 'Set as Live Wallpaper',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            _downloadVideo();
                            _startHideTimer(); // Reset timer on interaction
                          },
                          icon: const Icon(Icons.download),
                          label: const Text(
                            'Download Video',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
}
