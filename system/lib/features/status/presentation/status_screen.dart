import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/core/theme/app_theme.dart';
import 'package:system/features/auth/presentation/auth_state_provider.dart';
import 'package:system/features/home/presentation/welcome_screen.dart';
import 'package:system/features/status/presentation/status_controller.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  // Aesthetic Colors (matching auth screens)
  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _cardBg = Color(0xFF1A0B2E);
  static const Color _accentPurple = Color(0xFF9D4EDD);
  static const Color _neonPurple = Color(0xFFB000FF);
  // static const Color _textWhite = Colors.white; // Unused

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(statusControllerProvider);

    return Scaffold(
      backgroundColor: _bgDark,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'STATUS WINDOW',
          style: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              BoxShadow(
                color: _neonPurple.withValues(alpha: 0.8),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        backgroundColor: _bgDark.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: _accentPurple),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: _accentPurple),
            onPressed: () {
              ref.read(statusControllerProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.alertRed),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [_cardBg, _bgDark],
          ),
        ),
        child: state.when(
          data: (data) => _buildStatusBody(context, data),
          loading: () => const Center(
            child: CircularProgressIndicator(color: _neonPurple),
          ),
          error: (err, stack) => Center(
            child: Text(
              'SYSTEM ERROR: ${err.toString()}',
              style: GoogleFonts.rajdhani(
                color: AppTheme.alertRed,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBody(BuildContext context, Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildInfoCard(context, data),
          const SizedBox(height: 24),
          _buildSectionTitle('STATS'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(context, 'STR', data['strength'] ?? 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(context, 'AGI', data['agility'] ?? 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(
                  context,
                  'INT',
                  data['intelligence'] ?? 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(context, 'VIT', data['vitality'] ?? 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatTile(context, 'PER', data['perception'] ?? 10),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _accentPurple,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _accentPurple.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: _neonPurple.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NAME',
                      style: GoogleFonts.rajdhani(
                        color: _accentPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      data['username']?.toUpperCase() ?? 'UNKNOWN',
                      style: GoogleFonts.orbitron(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _neonPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _neonPurple.withValues(alpha: 0.5)),
                ),
                child: Text(
                  'LVL ${data['level'] ?? 1}',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: _accentPurple, height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('JOB', data['job'] ?? 'NONE'),
              _buildInfoItem('TITLE', data['title'] ?? 'NONE'),
              _buildInfoItem('RANK', data['rank'] ?? 'E', isRank: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {bool isRank = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.rajdhani(
            color: _accentPurple.withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toUpperCase(),
          style: GoogleFonts.rajdhani(
            color: isRank ? AppTheme.gold : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile(BuildContext context, String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: _bgDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentPurple.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.orbitron(
              color: _accentPurple,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
