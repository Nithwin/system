import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/auth/presentation/auth_state_provider.dart';
import 'package:system/features/home/presentation/welcome_screen.dart';
import 'package:system/features/status/presentation/status_controller.dart';
import 'dart:async';

class StatusScreen extends ConsumerStatefulWidget {
  const StatusScreen({super.key});

  @override
  ConsumerState<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends ConsumerState<StatusScreen> {
  // Aesthetic Colors
  static const Color _bgDark = Color(0xFF000000); // Pitch black for System
  static const Color _cardBg = Color(0xFF0F0F1A);
  static const Color _accentBlue = Color(0xFF2E86DE); // Jin-Woo Blue
  static const Color _neonBlue = Color(0xFF00D2D3);
  static const Color _alertRed = Color(0xFFFF4757);

  Timer? _timer;
  Duration _timeUntilReset = const Duration(hours: 0, minutes: 0, seconds: 0);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Calculate time until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _timeUntilReset = tomorrow.difference(now);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeUntilReset.inSeconds > 0) {
            _timeUntilReset = _timeUntilReset - const Duration(seconds: 1);
          } else {
            // Reset logic could go here
            final now = DateTime.now();
            final tomorrow = DateTime(now.year, now.month, now.day + 1);
            _timeUntilReset = tomorrow.difference(now);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    return '${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statusControllerProvider);

    return Scaffold(
      backgroundColor: _bgDark,
      appBar: AppBar(
        title: Text(
          'PLAYER STATUS',
          style: GoogleFonts.orbitron(
            fontSize: 20, // Compact size
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: _accentBlue),
            onPressed: () =>
                ref.read(statusControllerProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: _alertRed),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).setUnauthenticated();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: state.when(
        data: (data) => _buildBody(data),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: _neonBlue)),
        error: (e, s) => Center(
          child: Text('ERROR: $e', style: TextStyle(color: _alertRed)),
        ),
      ),
    );
  }

  Widget _buildBody(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 1. Time Remaining Panel
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: _alertRed.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
              color: _alertRed.withOpacity(0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PENALTY ZONE RESET',
                  style: GoogleFonts.rajdhani(
                    color: _alertRed,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatDuration(_timeUntilReset),
                  style: GoogleFonts.orbitron(
                    color: _alertRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Profile Header (Compact)
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _neonBlue, width: 2),
                  color: _cardBg,
                ),
                alignment: Alignment.center,
                child: Text(
                  data['username']?.substring(0, 1).toUpperCase() ?? 'P',
                  style: GoogleFonts.orbitron(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['username']?.toUpperCase() ?? 'PLAYER',
                      style: GoogleFonts.orbitron(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LEVEL ${data['level'] ?? 1}  •  ${data['job'] ?? 'NONE'}',
                      style: GoogleFonts.rajdhani(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // XP Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: ((data['xp'] ?? 0) / 1000).clamp(0.0, 1.0),
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(_accentBlue),
                        minHeight: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),

          // 3. Stats Grid
          _buildSectionHeader('STATISTICS'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('STRENGTH', data['strength'])),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard('AGILITY', data['agility'])),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard('INTEL', data['intelligence'])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildStatCard('VITALITY', data['vitality'])),
              const SizedBox(width: 10),
              Expanded(child: _buildStatCard('SENSE', data['perception'])),
            ],
          ),

          const SizedBox(height: 24),

          // 4. Notifications / Messages
          _buildSectionHeader('NOTIFICATIONS'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotifItem('Daily Quest "Pushups" has arrived.', 'Now'),
                const Divider(color: Colors.white10, height: 24),
                _buildNotifItem('Welcome to the System.', '2h ago'),
              ],
            ),
          ),

          const SizedBox(height: 24),
          // 5. Ranking Score
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_accentBlue.withOpacity(0.2), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: _neonBlue, width: 4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GLOBAL RANKING',
                      style: GoogleFonts.rajdhani(
                        color: _neonBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '#14,203',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.emoji_events, color: AppTheme.gold, size: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.rajdhani(
        color: Colors.white54,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        fontSize: 12,
      ),
    );
  }

  Widget _buildStatCard(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.rajdhani(
              color: _accentBlue,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value ?? 10}',
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifItem(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, color: Colors.white54, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.rajdhani(color: Colors.white, fontSize: 14),
          ),
        ),
        Text(
          time,
          style: GoogleFonts.rajdhani(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }
}
