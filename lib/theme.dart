import 'package:flutter/material.dart';

class AppColors {
  static const Color darkBackground = Color(0xFF090E1A); // Deep rich dark background
  static const Color cardBackground = Color(0xFF151E2E); // Sleek card background
  static const Color accentTeal = Color(0xFF00E5FF); // Electric Neon Teal/Cyan
  static const Color textPrimary = Color(0xFFFFFFFF); // Pure white
  static const Color textSecondary = Color(0xFF94A3B8); // Muted slate text
  
  // Legacy mapping compatibility
  static const Color lightBlue = Color(0xFF090E1A); // Maps to dark background
  static const Color blue = Color(0xFF00E5FF); // Maps to electric teal
  static const Color buttonBlue = Color(0xFF151E2E); // Maps to card background
  static const Color highlightBlue = Color(0xFF0F2B48); // Muted dark blue highlight
  static const Color darkBlue = Color(0xFFFFFFFF); // Maps to text primary
}
