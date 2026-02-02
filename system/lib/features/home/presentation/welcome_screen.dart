import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:system/features/auth/login_screen.dart';
import 'package:system/features/auth/register_screen.dart';
import 'dart:math' as math;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _gridController;
  late AnimationController _pulseController;

  // Aesthetic Colors (Mystic Portal Theme)
  static const Color _bgDark = Color(0xFF0F0518);
  static const Color _accentPurple = Color(0xFF9D4EDD);
  static const Color _neonPurple = Color(0xFFB000FF);

  @override
  void initState() {
    super.initState();
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gridController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _bgDark,
                    Color(0xFF1A0B2E), // Deep Purple
                    _bgDark,
                  ],
                ),
              ),
            ),
          ),
          // Animated Grid
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([_gridController, _pulseController]),
              builder: (context, child) {
                return CustomPaint(
                  painter: HexGridPainter(
                    offset: _gridController.value,
                    pulse: _pulseController.value,
                    color: _neonPurple,
                  ),
                );
              },
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    _buildSystemBox(),
                    const Spacer(),
                    _buildButtons(context),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemBox() {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            border: Border.all(
              color: _accentPurple.withValues(alpha: 0.6),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: _neonPurple.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _bgDark.withValues(alpha: 0.95),
                const Color(0xFF1A0B2E).withValues(alpha: 0.9),
              ],
            ),
          ),
          child: Column(
            children: [
              // SYSTEM Title
              Text(
                    'SYSTEM',
                    style: GoogleFonts.orbitron(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: _neonPurple.withValues(alpha: 0.8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: _neonPurple.withValues(alpha: 0.3),
                  ),
              const SizedBox(height: 24),
              // Subtitle
              Text(
                'PLAYER E-RANK AWAKENING PROTOCOL',
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: 11,
                  color: _accentPurple.withValues(alpha: 0.7),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      _neonPurple.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Welcome
              Text(
                'Welcome, Player.',
                style: GoogleFonts.rajdhani(
                  fontSize: 24,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 1000.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 1000.ms);
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Login Button
        SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _neonPurple.withValues(alpha: 0.8),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  shadowColor: _neonPurple.withValues(alpha: 0.3),
                  elevation: 8,
                ),
                child: Text(
                  'ACCESS SYSTEM',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _neonPurple,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 1200.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 1200.ms),
        const SizedBox(height: 16),
        // Register Button
        SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: _accentPurple.withValues(alpha: 0.6),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'INITIATE AWAKENING',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _accentPurple.withValues(alpha: 0.9),
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 1400.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 1400.ms),
      ],
    );
  }
}

class HexGridPainter extends CustomPainter {
  final double offset;
  final double pulse;
  final Color color;

  HexGridPainter({
    required this.offset,
    required this.pulse,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.15 * (0.5 + pulse * 0.5))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double hexSize = 50.0;
    const double hexHeight = hexSize * 2;
    const double hexWidth = hexSize * 1.732; // sqrt(3)

    final int rows = (size.height / (hexHeight * 0.75)).ceil() + 2;
    final int cols = (size.width / hexWidth).ceil() + 2;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double xOffset = (r % 2) * (hexWidth / 2);
        final double x = c * hexWidth + xOffset - (offset * hexWidth);
        final double y = r * (hexHeight * 0.75) - (offset * hexHeight * 0.5);

        _drawHexagon(canvas, x, y, hexSize, paint);
      }
    }
  }

  void _drawHexagon(
    Canvas canvas,
    double x,
    double y,
    double size,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final double angle = (60 * i + 30) * (math.pi / 180);
      final double px = x + size * math.cos(angle);
      final double py = y + size * math.sin(angle);
      if (i == 0) {
        path.moveTo(px, py);
      } else {
        path.lineTo(px, py);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(HexGridPainter oldDelegate) =>
      offset != oldDelegate.offset || pulse != oldDelegate.pulse;
}
