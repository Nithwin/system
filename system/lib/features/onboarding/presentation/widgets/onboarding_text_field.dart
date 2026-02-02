import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isNumber;
  final VoidCallback? onTap;
  final bool readOnly;
  final IconData? suffixIcon;

  const OnboardingTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isNumber = false,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
  });

  @override
  State<OnboardingTextField> createState() => _OnboardingTextFieldState();
}

class _OnboardingTextFieldState extends State<OnboardingTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color accentPurple = Color(0xFF9D4EDD);
    const Color inputBg = Color(0xFF1A0B2E);
    const Color neonPurple = Color(0xFFB000FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.orbitron(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: _isFocused ? neonPurple : accentPurple,
            letterSpacing: 1,
            shadows: _isFocused
                ? [
                    BoxShadow(
                      color: neonPurple.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: inputBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused
                  ? neonPurple
                  : accentPurple.withValues(alpha: 0.3),
              width: _isFocused ? 1.5 : 1.0,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: neonPurple.withValues(alpha: 0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.isNumber
                ? TextInputType.number
                : TextInputType.text,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.rajdhani(
                color: Colors.white.withValues(alpha: 0.2),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: widget.suffixIcon != null
                  ? Icon(
                      widget.suffixIcon,
                      color: _isFocused
                          ? neonPurple
                          : accentPurple.withValues(alpha: 0.5),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
