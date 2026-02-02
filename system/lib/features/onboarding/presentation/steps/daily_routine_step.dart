import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/onboarding/presentation/widgets/onboarding_text_field.dart';

class DailyRoutineStep extends StatelessWidget {
  final TextEditingController hoursController;
  final TextEditingController sleepController;

  const DailyRoutineStep({
    super.key,
    required this.hoursController,
    required this.sleepController,
  });

  static const Color _accentPurple = Color(0xFF9D4EDD);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('DAILY ROUTINE', 'Time Analysis'),
          const SizedBox(height: 32),
          OnboardingTextField(
            label: 'HOURS AVAILABLE PER DAY',
            hint: 'e.g. 4',
            controller: hoursController,
            isNumber: true,
          ),
          const SizedBox(height: 16),
          OnboardingTextField(
            label: 'SLEEP SCHEDULE (HOURS)',
            hint: 'e.g. 7',
            controller: sleepController,
            isNumber: true,
          ),
          const SizedBox(height: 24),
          Text(
            'SYSTEM NOTE: Consistent sleep promotes rapid rank up.',
            style: GoogleFonts.rajdhani(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.rajdhani(color: _accentPurple, fontSize: 18),
        ),
      ],
    );
  }
}
