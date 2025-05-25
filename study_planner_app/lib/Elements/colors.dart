import 'package:flutter/material.dart';

// Modern gradient colors
Color primaryColor = const Color(0xFF6C63FF);
Color secondaryColor = const Color(0xFF4ECDC4);
Color accentColor = const Color(0xFFFF6B6B);
Color successColor = const Color(0xFF4CAF50);
Color warningColor = const Color(0xFFFF9800);

// Gradient definitions
LinearGradient primaryGradient = const LinearGradient(
  colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient cardGradient = const LinearGradient(
  colors: [Color(0xFF2C2C54), Color(0xFF1A1A2E)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

LinearGradient backgroundGradient = const LinearGradient(
  colors: [Color(0xFF0F0F23), Color(0xFF16213E)],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Legacy colors for backward compatibility
Color lightBlue = const Color(0xFF4ECDC4);
Color darkBlue = const Color(0xFF6C63FF);

// Text colors
Color primaryTextColor = const Color(0xFFFFFFFF);
Color secondaryTextColor = const Color(0xFFB0B0B0);
Color hintTextColor = const Color(0xFF757575);

// Surface colors
Color surfaceColor = const Color(0xFF2C2C54);
Color cardColor = const Color(0xFF1A1A2E);
Color dividerColor = const Color(0xFF3A3A5C);
