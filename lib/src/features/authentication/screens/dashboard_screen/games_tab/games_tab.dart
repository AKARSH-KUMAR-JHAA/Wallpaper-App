import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminawall/src/common_widget/standard_header.dart';
import 'package:luminawall/src/constants/colors_strings.dart';
import 'package:luminawall/src/features/authentication/controller/rewards_controller.dart';
import 'package:confetti/confetti.dart';
import 'package:luminawall/src/features/authentication/models/wallpaper_model.dart';
import 'package:luminawall/src/features/authentication/screens/wallpaper_full_screen/wallpaper_full_screen.dart';
// missing import removed

class GamesTab extends StatefulWidget {
  const GamesTab({super.key});

  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  static const int gridSize = 20;
  List<Offset> snake = [const Offset(10, 10)];
  Offset food = const Offset(15, 15);
  String direction = 'UP';
  Timer? timer;
  int score = 0;
  bool isPlaying = false;
  final int winningScore = 5;
  late ConfettiController _confettiController;
  final rewardsController = Get.put(RewardsController());

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      snake = [const Offset(10, 10)];
      score = 0;
      direction = 'UP';
      isPlaying = true;
      spawnFood();
    });
    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 150), (Timer t) {
      updateSnake();
    });
  }

  void stopGame() {
    setState(() {
      isPlaying = false;
    });
    timer?.cancel();
  }

  void spawnFood() {
    final random = Random();
    food = Offset(
      random.nextInt(gridSize).toDouble(),
      random.nextInt(gridSize).toDouble(),
    );
    // Ensure food doesn't spawn on the snake
    while (snake.contains(food)) {
      food = Offset(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    }
  }

  void updateSnake() {
    setState(() {
      Offset head = snake.first;
      switch (direction) {
        case 'UP':
          head = Offset(head.dx, head.dy - 1);
          break;
        case 'DOWN':
          head = Offset(head.dx, head.dy + 1);
          break;
        case 'LEFT':
          head = Offset(head.dx - 1, head.dy);
          break;
        case 'RIGHT':
          head = Offset(head.dx + 1, head.dy);
          break;
      }

      // Check collision with walls or self
      if (head.dx < 0 ||
          head.dx >= gridSize ||
          head.dy < 0 ||
          head.dy >= gridSize ||
          snake.contains(head)) {
        stopGame();
        _showGameOverDialog();
        return;
      }

      snake.insert(0, head);

      // Check if food eaten
      if (head == food) {
        score++;
        if (score >= winningScore) {
          stopGame();
          _triggerWinSequence();
        } else {
          spawnFood();
        }
      } else {
        snake.removeLast();
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? kJungleMossDark
              : kJungleCream,
          title: const Text('Game Over!',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'Your score: $score\nYou need $winningScore to unlock the reward.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startGame();
              },
              child: const Text('Try Again',
                  style: TextStyle(color: kJungleEmerald)),
            )
          ],
        );
      },
    );
  }

  Future<void> _triggerWinSequence() async {
    _confettiController.play();

    // Attempt to unlock a new reward
    rewardsController.isUnlocking.value = true;
    final reward = await rewardsController.unlockRandomReward();
    rewardsController.isUnlocking.value = false;

    _showWinDialog(reward);
  }

  void _showWinDialog(Photo? unlockedReward) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? kJungleMossDark
              : kJungleCream,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 30),
              SizedBox(width: 10),
              Text('You Won!', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Congratulations! You have unlocked an exclusive new wallpaper.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              if (unlockedReward != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(unlockedReward.src.medium,
                      height: 150, fit: BoxFit.cover),
                )
              else
                const CircularProgressIndicator(color: kJungleEmerald),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                startGame();
              },
              child: const Text('Play Again',
                  style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kJungleEmerald,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (unlockedReward != null) {
                  Get.to(() => const RetroRewardsScreen());
                }
              },
              child: const Text('View Rewards',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          kJungleDeepGreen,
                          kJungleMossDark,
                        ]
                      : [
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
                  title: 'ARCADE', subtitle: 'PLAY TO UNLOCK REWARDS'),
              const SizedBox(height: 10),
              // View Rewards Button
              ElevatedButton.icon(
                onPressed: () => Get.to(() => const RetroRewardsScreen()),
                icon: const Icon(Icons.stars_rounded, color: Colors.orange),
                label: const Text('MY REWARDS',
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kJungleMossDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
              ),
              const SizedBox(height: 15),

              // Score Board
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: isDark
                      ? kJungleEmerald.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border:
                      Border.all(color: kJungleEmerald.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Score: $score',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : kJungleDeepGreen,
                      ),
                    ),
                    Text(
                      'Target: $winningScore',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kJungleEmerald.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),
              // Game Board
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.5)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: kJungleEmerald.withValues(alpha: 0.5),
                              width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: kJungleEmerald.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cellSize = constraints.maxWidth / gridSize;
                          return Stack(
                            children: [
                              // Food
                              Positioned(
                                left: food.dx * cellSize,
                                top: food.dy * cellSize,
                                child: Icon(
                                  Icons.fastfood,
                                  size: cellSize,
                                  color: Colors.amber,
                                ),
                              ),
                              // Snake
                              ...snake.asMap().entries.map((entry) {
                                int index = entry.key;
                                Offset segment = entry.value;
                                bool isHead = index == 0;
                                return AnimatedPositioned(
                                  key: ValueKey(index),
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.linear,
                                  left: segment.dx * cellSize,
                                  top: segment.dy * cellSize,
                                  child: Container(
                                    width: cellSize,
                                    height: cellSize,
                                    padding: const EdgeInsets.all(1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isHead
                                            ? kJungleEmerald
                                            : Colors.lightGreenAccent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                );
                              }),

                              // Overlay if not playing
                              if (!isPlaying)
                                Positioned.fill(
                                  child: Container(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    child: Center(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kJungleEmerald,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: startGame,
                                        icon: const Icon(Icons.play_arrow,
                                            color: Colors.white, size: 30),
                                        label: const Text(
                                          'START GAME',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // D-Pad Controls
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: SizedBox(
                  width: 144,
                  height: 144,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: _buildControlButton(
                            Icons.keyboard_arrow_up_rounded, () {
                          if (direction != 'DOWN') direction = 'UP';
                        }),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildControlButton(
                            Icons.keyboard_arrow_left_rounded, () {
                          if (direction != 'RIGHT') direction = 'LEFT';
                        }),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _buildControlButton(
                            Icons.keyboard_arrow_right_rounded, () {
                          if (direction != 'LEFT') direction = 'RIGHT';
                        }),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: _buildControlButton(
                            Icons.keyboard_arrow_down_rounded, () {
                          if (direction != 'UP') direction = 'DOWN';
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          // Fireworks Overlay over everything
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // radial
              shouldLoop: false,
              emissionFrequency: 0.1,
              numberOfParticles: 30,
              gravity: 0.2,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? kJungleEmerald.withValues(alpha: 0.2)
              : kJungleMossDark.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
              color: kJungleEmerald.withValues(alpha: 0.5), width: 2),
        ),
        child: Icon(icon,
            size: 24, color: isDark ? Colors.white : kJungleDeepGreen),
      ),
    );
  }
}

class RetroRewardsScreen extends StatelessWidget {
  const RetroRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rewardsController = Get.put(RewardsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          kJungleDeepGreen,
                          kJungleMossDark,
                        ]
                      : [
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: isDark ? Colors.white : Colors.black,
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
                    child: StandardHeader(
                        title: 'REWARDS', subtitle: 'YOUR EXCLUSIVE UNLOCKS'),
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (rewardsController.unlockedRewards.isEmpty) {
                    return Center(
                      child: Text('Play games to unlock rewards!',
                          style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontSize: 16)),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: rewardsController.unlockedRewards.length,
                    itemBuilder: (context, idx) {
                      var photo = rewardsController.unlockedRewards[idx];
                      var imageUrl = photo.src.large;
                      return GestureDetector(
                        onTap: () {
                          // Route to apply wallpaper
                          Get.to(() =>
                              WallpaperFullScreen(imageUrl, photo: photo));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(fit: StackFit.expand, children: [
                            Image.network(photo.src.medium, fit: BoxFit.cover),
                            Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.7)
                                ],
                              )),
                            ),
                            const Positioned(
                              bottom: 10,
                              right: 10,
                              child: Icon(Icons.format_paint_rounded,
                                  color: Colors.white, size: 24),
                            )
                          ]),
                        ),
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
