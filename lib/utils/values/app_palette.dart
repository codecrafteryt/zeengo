import 'package:flutter/material.dart';

/// Cursor-like light / dark surfaces used across the app.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.scaffold,
    required this.card,
    required this.cardMuted,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.icon,
    required this.divider,
    required this.inputFill,
    required this.navBar,
    required this.overlay,
  });

  final Color scaffold;
  final Color card;
  final Color cardMuted;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color icon;
  final Color divider;
  final Color inputFill;
  final Color navBar;
  final Color overlay;

  static const light = AppPalette(
    scaffold: Color(0xFFF7F7F7),
    card: Color(0xFFFFFFFF),
    cardMuted: Color(0xFFF9F9F9),
    border: Color(0xFFDDDDDD),
    textPrimary: Color(0xFF262626),
    textSecondary: Color(0xFF717171),
    icon: Color(0xFF262626),
    divider: Color(0xFFDDDDDD),
    inputFill: Color(0xFFFFFFFF),
    navBar: Color(0xFFF7F7F7),
    overlay: Color(0x73000000),
  );

  /// Cursor-inspired near-black aesthetic.
  static const dark = AppPalette(
    scaffold: Color.fromRGBO(0, 0, 0, 1),
    card: Color(0xFF141414),
    cardMuted: Color(0xFF1A1A1A),
    border: Color(0xFF2A2A2A),
    textPrimary: Color(0xFFE8E8E8),
    textSecondary: Color(0xFF9B9B9B),
    icon: Color(0xFFE8E8E8),
    divider: Color(0xFF2A2A2A),
    inputFill: Color(0xFF141414),
    navBar: Color(0xFF0A0A0A),
    overlay: Color(0x99000000),
  );

  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ?? AppPalette.light;
  }

  @override
  AppPalette copyWith({
    Color? scaffold,
    Color? card,
    Color? cardMuted,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? icon,
    Color? divider,
    Color? inputFill,
    Color? navBar,
    Color? overlay,
  }) {
    return AppPalette(
      scaffold: scaffold ?? this.scaffold,
      card: card ?? this.card,
      cardMuted: cardMuted ?? this.cardMuted,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      icon: icon ?? this.icon,
      divider: divider ?? this.divider,
      inputFill: inputFill ?? this.inputFill,
      navBar: navBar ?? this.navBar,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardMuted: Color.lerp(cardMuted, other.cardMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }
}
