import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/features/quests/presentation/quest_controller.dart';

class DungeonBattleScreen extends ConsumerStatefulWidget {
  final Quest dungeon;

  const DungeonBattleScreen({super.key, required this.dungeon});

  @override
  ConsumerState<DungeonBattleScreen> createState() => _DungeonBattleScreenState();
}

class _DungeonBattleScreenState extends ConsumerState<DungeonBattleScreen> {
  Timer? _timer;
  Duration _timeLeft = const Duration(minutes: 10); // Default 10 mins
  bool _isBattleActive = true;
  bool _isFailed = false;

  @override
  void initState() {
    super.initState();
    _startBattle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startBattle() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft.inSeconds <= 0) {
        _failBattle();
      } else {
        setState(() {
          _timeLeft -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _failBattle() {
    _timer?.cancel();
    setState(() {
      _isBattleActive = false;
      _isFailed = true;
    });
  }

  void _completeBattle() {
    _timer?.cancel();
    // Call controller to complete
    ref.read(questControllerProvider.notifier).toggleQuest(widget.dungeon.id);
    
    // Show Success Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0B2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.amber, size: 60),
              const SizedBox(height: 16),
              Text(
                "DUNGEON CLEARED",
                style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
              ),
               const SizedBox(height: 8),
              Text(
                "Rewards obtained.",
                style: GoogleFonts.rajdhani(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close Dialog
                  Navigator.pop(context); // Close Screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
                child: Text("LEAVE DUNGEON", style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_isFailed) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "YOU DIED",
                style: GoogleFonts.orbitron(color: Colors.red[900], fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "The instance dungeon has closed.",
                style: GoogleFonts.rajdhani(color: Colors.white54),
              ),
               const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  foregroundColor: Colors.redAccent,
                ),
                child: Text("RETURN", style: GoogleFonts.orbitron()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0518),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Boss Visual
             Center(
               child: Opacity(
                 opacity: 0.1,
                 child: Icon(Icons.adb, size: 400, color: Colors.red), // Placeholder for Monster
               ),
             ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Timer Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Text(
                        _formatDuration(_timeLeft),
                        style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 32, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  const Spacer(),
                  
                  // Boss Info
                  GlassBox(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          widget.dungeon.title.toUpperCase(),
                          style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          "Objective: Defeat the boss within the time limit.",
                          style: GoogleFonts.rajdhani(color: Colors.white70),
                        ),
                        const SizedBox(height: 24),
                        
                        // Fake Boss Health Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: const LinearProgressIndicator(
                            value: 0.7, // Mock
                            color: Colors.red,
                            backgroundColor: Colors.white10,
                            minHeight: 12,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                         SizedBox(
                           width: double.infinity,
                           child: ElevatedButton(
                             onPressed: _completeBattle,
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Colors.redAccent,
                               padding: const EdgeInsets.symmetric(vertical: 20),
                             ),
                             child: Text(
                               "ATTACK (COMPLETE)",
                               style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                             ),
                           ),
                         ),
                      ],
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
}
