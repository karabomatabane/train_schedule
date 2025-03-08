import 'package:flutter/material.dart';

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFFFB0D0),
  onPrimary: Color(0xFF5C113B),
  primaryContainer: Color(0xFF792952),
  onPrimaryContainer: Color(0xFFFFD8E6),
  secondary: Color(0xFFB5838D),  // Muted warm tone for harmony
  onSecondary: Color(0xFF3E2C33), // Darker, subtle contrast
  tertiary: Color(0xFFE5989B),   // Lighter, softer tone
  onTertiary: Color(0xFF274874), // Dark to enhance contrast
  error: Color(0xFFCF6679),       // Softer error to blend with dark themes
  onError: Color(0xFF1E1E1E),     // Dark to enhance contrast
  surface: Color(0xFF101E31),
  onSurface: Color(0xFFA8DADC),   // This works well with the cool surface
  background: Color(0xFF0D1B2A),
  onBackground: Color(0xFFA8DADC), // This works well with the cool background
);