import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/quests/domain/quest_model.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onToggle;

  const QuestCard({super.key, required this.quest, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    // Aesthetic Colors
    const Color bgDark = Color(0xFF0F0518);
    final Color systemBlue = quest.isCompleted
        ? const Color(0xFF00FF00)
        : const Color(0xFF00AEEF);
    const Color cardBg = Color(0xFF1A0B2E);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg.withValues(alpha: 0.8),
        border: Border.all(
          color: systemBlue.withValues(alpha: quest.isCompleted ? 0.3 : 0.6),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: systemBlue.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox / Status
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 4, right: 16),
                  decoration: BoxDecoration(
                    color: quest.isCompleted
                        ? systemBlue.withValues(alpha: 0.2)
                        : Colors.transparent,
                    border: Border.all(color: systemBlue),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: quest.isCompleted
                      ? Icon(Icons.check, size: 16, color: systemBlue)
                      : null,
                ),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            quest.difficulty,
                            style: GoogleFonts.orbitron(
                              color: _getDifficultyColor(quest.difficulty),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (quest.isCompleted)
                            Text(
                              'COMPLETE',
                              style: GoogleFonts.orbitron(
                                color: systemBlue,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            )
                          else
                            Text(
                              'ACTIVE',
                              style: GoogleFonts.orbitron(
                                color: systemBlue,
                                fontSize: 10,
                                letterSpacing: 1,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        quest.title.toUpperCase(),
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: quest.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: systemBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quest.description,
                        style: GoogleFonts.rajdhani(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'REWARD: ${quest.reward}',
                          style: GoogleFonts.rajdhani(
                            color: const Color(0xFFFFD700), // Gold
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'E':
        return Colors.white;
      case 'D':
        return Colors.green;
      case 'C':
        return Colors.blue;
      case 'B':
        return Colors.purple;
      case 'A':
        return Colors.red;
      case 'S':
        return Colors.orange; // Gold/Legendary
      default:
        return Colors.white;
    }
  }
}
