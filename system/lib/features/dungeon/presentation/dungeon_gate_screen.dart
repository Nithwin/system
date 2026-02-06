import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/presentation/widgets/glass_box.dart';
import 'package:system/features/quests/domain/quest_model.dart';
import 'package:system/features/quests/presentation/quest_controller.dart';
import 'package:system/features/dungeon/presentation/dungeon_battle_screen.dart';

class DungeonGateScreen extends ConsumerWidget {
  const DungeonGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real app, we might have a separate endpoint for Dungeons, 
    // but here we filter quests by type 'DUNGEON' or similar convention
    // Since we just added the enum, we assume quests with type 'DUNGEON' will come from repository.
    final questsAsync = ref.watch(questControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF050000), // Very dark red/black
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("DUNGEON GATE", style: GoogleFonts.orbitron(color: Colors.redAccent, letterSpacing: 2)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/gate_bg.png'), // Placeholder
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken),
            fit: BoxFit.cover,
          ),
        ),
        child: questsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Colors.redAccent)),
          error: (e, s) => Center(child: Text("Gate Closed: $e", style: const TextStyle(color: Colors.red))),
          data: (quests) {
            final dungeons = quests.where((q) => q.type == 'DUNGEON').toList();
            
            if (dungeons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_outline, color: Colors.white24, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      "NO GATES DETECTED",
                      style: GoogleFonts.orbitron(color: Colors.white24, fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dungeons.length,
              itemBuilder: (context, index) {
                final dungeon = dungeons[index];
                return _buildDungeonCard(context, dungeon);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDungeonCard(BuildContext context, Quest dungeon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassBox(
        borderRadius: BorderRadius.circular(12),
        borderColor: Colors.redAccent.withOpacity(0.5),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DungeonBattleScreen(dungeon: dungeon)),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Rank/Icon
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Center(
                    child: Text(
                      dungeon.difficulty,
                      style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dungeon.title.toUpperCase(),
                        style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rewards: item_box, ${dungeon.xp} XP", // Mocking item box
                        style: GoogleFonts.rajdhani(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                
                // Gate Icon
                const Icon(Icons.arrow_forward_ios, color: Colors.redAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
