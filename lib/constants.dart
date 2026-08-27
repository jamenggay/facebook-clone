import 'package:flutter/material.dart';

const String host = 'https://dummyjson.com';

/// Global flag that tells the color getters below whether the app is currently
/// in dark mode. It is updated by ThemeProvider.toggleTheme(). Because the root
/// MaterialApp listens to ThemeProvider, toggling rebuilds the whole widget
/// tree, so every widget re-reads these getters and picks up the new palette.
bool fbDarkMode = false;

// ---------------------------------------------------------------------------
// Colors that stay the SAME in both light and dark mode.
// These are the brand accents used on colored bars/borders where the contrast
// already works against both light and dark surfaces.
// ---------------------------------------------------------------------------

const Color FB_SECONDARY = Color(0xFFA9B5DF);
// App bars, bottom navigation, buttons and input borders.
const Color FB_LIGHT_PRIMARY = Color(0xFF7886C7);
// Text/icons placed on top of the colored (FB_LIGHT_PRIMARY) bars.
const Color FB_TEXT_COLOR_WHITE = Color(0xFFFFF2F2);

// ---------------------------------------------------------------------------
// Colors that ADAPT to the current theme. Each getter returns the dark-mode
// value when fbDarkMode is true, otherwise the original light-mode value.
// ---------------------------------------------------------------------------

/// General page background (Scaffold body). Off-white in light, near-black in dark.
Color get FB_SURFACE =>
    fbDarkMode ? const Color(0xFF18191A) : const Color(0xFFFFF2F2);

/// Card / input-field surface, slightly raised from the page background.
Color get FB_CARD =>
    fbDarkMode ? const Color(0xFF242526) : const Color(0xFFFFF2F2);

/// Primary accent for headings and links (navy in light, lavender in dark for
/// readability on the dark background).
Color get FB_PRIMARY =>
    fbDarkMode ? const Color(0xFFA9B5DF) : const Color(0xFF2D336B);

/// Strong accent for icons, tab indicators and emphasized text.
Color get FB_DARK_PRIMARY =>
    fbDarkMode ? const Color(0xFFA9B5DF) : const Color(0xFF2D336B);

/// Primary body text. Near-black on light surfaces, near-white on dark ones.
Color get FB_TEXT_PRIMARY =>
    fbDarkMode ? const Color(0xFFE4E6EB) : const Color(0xFF050505);

/// Secondary/muted text.
Color get FB_TEXT_COLOR_GREY =>
    fbDarkMode ? const Color(0xFFB0B3B8) : const Color(0xFF606770);

/// Muted text (darker grey variant in light mode).
Color get FB_TEXT_COLOR_DARKGREY =>
    fbDarkMode ? const Color(0xFFB0B3B8) : const Color(0xFF4C525E);
