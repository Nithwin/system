import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/features/quests/presentation/quest_controller.dart';

class QuestDetailScreen extends ConsumerStatefulWidget {
  final Quest quest;

  const QuestDetailScreen({super.key, required this.quest});

  @override
  ConsumerState<QuestDetailScreen> createState() => _QuestDetailScreenState();
}

class _QuestDetailScreenState extends ConsumerState<QuestDetailScreen> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _duration += const Duration(seconds: 1);
        });
      });
    }
  }

  void _completeQuest() {
    // Stop timer if running
    _timer?.cancel();
    
    // Call controller
    ref.read(questControllerProvider.notifier).toggleQuest(widget.quest.id);
    
    // Go back
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Mission Completed! +${widget.quest.xp} XP", style: GoogleFonts.orbitron()),
        backgroundColor: Colors.amber,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final isPhysical = widget.quest.type == 'PHYSICAL';
    final isTechnical = widget.quest.type == 'TECHNICAL';
    
    Color accentColor = isPhysical ? Colors.redAccent : (isTechnical ? Colors.cyanAccent : Colors.purpleAccent);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0518),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0518),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.quest.title.toUpperCase(), style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header Card
            GlassBox(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentColor),
                    ),
                    child: Text(
                      "DIFFICULTY: ${widget.quest.difficulty}",
                      style: GoogleFonts.orbitron(color: accentColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                     widget.quest.description,
                     textAlign: TextAlign.center,
                     style: GoogleFonts.rajdhani(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "+${widget.quest.xp} XP",
                    style: GoogleFonts.orbitron(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Task Specifics
            if (isPhysical) ...[
               Text("TARGET", style: GoogleFonts.orbitron(color: Colors.white54, letterSpacing: 2)),
               const SizedBox(height: 8),
               Text(
                 "${widget.quest.target ?? 'Any'} ${widget.quest.unit ?? ''}",
                 style: GoogleFonts.orbitron(color: Colors.white, fontSize: 32),
               ),
            ],
            
            if (isTechnical) ...[
               Text("CHALLENGE", style: GoogleFonts.orbitron(color: Colors.white54, letterSpacing: 2)),
               const SizedBox(height: 8),
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: Colors.black45,
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.white10),
                 ),
                 child: Text(
                   widget.quest.description, // Re-using description as the challenge prompt for now
                   style: GoogleFonts.sourceCodePro(color: Colors.cyanAccent, fontSize: 14),
                 ),
               ),
            ],

            const Spacer(),
            
            // Timer
            Text(_formatDuration(_duration), style: GoogleFonts.orbitron(color: Colors.white, fontSize: 48)),
            const SizedBox(height: 16),
            
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? Colors.orangeAccent : accentColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    _isRunning ? "PAUSE" : "START TIMER",
                    style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                if (!widget.quest.isCompleted)
                  ElevatedButton(
                    onPressed: _completeQuest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      "COMPLETE",
                      style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
