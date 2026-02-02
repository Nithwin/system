import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/features/quests/presentation/widgets/quest_card.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  // Local state for MVP
  final List<Quest> _quests = [
    const Quest(
      id: '1',
      title: 'STRENGTH TRAINING [DAILY]',
      description: '100 Pushups\n100 Situps\n100 Squats\n10km Run',
      reward: 'Recover Fatigue, +3 Stat Points',
      difficulty: 'E',
      isCompleted: false,
    ),
    const Quest(
      id: '2',
      title: 'MEDITATION',
      description: 'Clear your mind for 15 minutes.',
      reward: '+1 Intelligence',
      difficulty: 'D',
      isCompleted: false,
    ),
    const Quest(
      id: '3',
      title: 'CODE REVIEW',
      description: 'Review 3 Pull Requests on GitHub.',
      reward: '+2 Intelligence',
      difficulty: 'C',
      isCompleted: false,
    ),
  ];

  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _systemBlue = Color(0xFF00AEEF);

  void _toggleQuest(int index) {
    setState(() {
      _quests[index] = _quests[index].copyWith(
        isCompleted: !_quests[index].isCompleted,
      );
    });

    if (_quests[index].isCompleted) {
      // Play sound or show snackbar later
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'QUESTS',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'SYSTEM ALERTS',
                style: GoogleFonts.rajdhani(
                  color: _systemBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // List
              Expanded(
                child: ListView.builder(
                  itemCount: _quests.length,
                  itemBuilder: (context, index) {
                    return QuestCard(
                      quest: _quests[index],
                      onToggle: () => _toggleQuest(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
