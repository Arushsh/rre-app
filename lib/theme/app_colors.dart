import 'package:flutter/material.dart';

class AppColors {
  // ── Requested Palette ──────────────────────────────────────────────────────
  // #0A192F — Deep Rich Dark Navy (Canvas & Base Background)
  // #172A45 — Dark Slate Navy (Cards, Surfaces, Modals, Navbars)
  // #64FFDA — Vibrant Electric Mint / Teal (Primary Accent, CTAs, Highlights)
  // #8892B0 — Cool Slate Gray (Secondary Text, Muted Borders, Inactive Items)
  // #E6F1FF — Crisp Ice White (Headings, Primary Text, Bright Accents)

  // --- BACKGROUNDS ---
  static const Color background    = Color(0xFF0A192F); // Deepest Dark Navy
  static const Color surface       = Color(0xFF172A45); // Elevated Navy Surface
  static const Color surfaceLight  = Color(0xFF203758); // Higher Elevation / Focused Surface

  // --- PRIMARY TEAL / MINT (#64FFDA) ---
  static const Color teal          = Color(0xFF64FFDA); // Direct token
  static const Color tealLight     = Color(0xFFA5FFEA); // Hover / Highlight Tint
  static const Color tealDark      = Color(0xFF00D9A5); // Gradient Endpoint

  // Aliases for seamless compatibility across existing widgets
  static const Color goldPrimary   = Color(0xFF64FFDA); // Primary Action / Active Tab
  static const Color goldLight     = Color(0xFF64FFDA); // Accents & Active Icons
  static const Color orangeAccent  = Color(0xFF00E5A3); // Vivid Teal-Green
  static const Color cyanAccent    = Color(0xFF64FFDA); // Glow halos & Radials

  // --- ICE WHITE ACCENT (#E6F1FF) ---
  static const Color iceWhite      = Color(0xFFE6F1FF); // Clean Ice White
  static const Color creamAccent   = Color(0xFFE6F1FF); // Highlights, Prices, Badges

  // --- SLATE GRAY (#8892B0) ---
  static const Color slate         = Color(0xFF8892B0); // Cool Slate
  static const Color slateLight    = Color(0xFFA8B2D1); // Light Slate
  static const Color purpleAccent  = Color(0xFF495670); // Deep Slate Accent
  static const Color pinkAccent    = Color(0xFFFF6492); // Vivid Accent / Alert

  // --- TEXT TOKENS ---
  static const Color textPrimary   = Color(0xFFE6F1FF); // Crisp #E6F1FF
  static const Color textSecondary = Color(0xFF8892B0); // Slate #8892B0
  static const Color textMuted     = Color(0x998892B0); // Faded Slate

  // --- GRADIENTS ---
  // Vibrant #64FFDA Gradient (Buttons, active badges)
  static const List<Color> primaryGradient = [
    Color(0xFF64FFDA),
    Color(0xFF00D9A5),
  ];

  // Dark Slate Navy Glass Gradient (#172A45 → #0A192F)
  static const List<Color> darkGlassGradient = [
    Color(0xFF172A45),
    Color(0xFF0A192F),
  ];

  // Subtle Card Surface Gradient
  static const List<Color> cardSurfaceGradient = [
    Color(0xCC172A45),
    Color(0x990A192F),
  ];
}
