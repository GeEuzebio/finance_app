import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tokens da direção "Horizonte" — base ink azulada, um único accent
/// âmbar (docs/DESIGN.md). Dark é o modo principal, mas light segue os
/// mesmos tokens (mesma família de matiz, pontos diferentes na rampa),
/// nunca um "invertido" arbitrário.
abstract final class AppColors {
  const AppColors._();

  static const inkBackgroundDark = Color(0xFF0E1116);
  static const inkSurfaceDark = Color(0xFF171B24);
  static const inkBackgroundLight = Color(0xFFF4F5F8);
  static const inkSurfaceLight = Color(0xFFFFFFFF);

  static const inkTextDark = Color(0xFFEDEFF3);
  static const inkTextLight = Color(0xFF14161C);
  static const inkTextMutedDark = Color(0xFF9297A6);
  static const inkTextMutedLight = Color(0xFF5B6072);

  static const inkBorderDark = Color(0xFF262B36);
  static const inkBorderLight = Color(0xFFE3E5EB);

  /// Accent único do produto — "olhar pra frente" (previsibilidade).
  /// Só em ação primária / destaque; nunca decoração solta.
  static const amber = Color(0xFFE8A33D);
  static const onAmber = Color(0xFF1A1300);

  // Semânticos de dinheiro: dessaturados pra não competir com o âmbar,
  // com variante por modo pra manter contraste mínimo de 4.5:1.
  static const creditDark = Color(0xFF5FB88A);
  static const creditLight = Color(0xFF2F8F63);
  static const debitDark = Color(0xFFD97066);
  static const debitLight = Color(0xFFB84D3F);

  static Color credit(Brightness b) => b == Brightness.dark ? creditDark : creditLight;
  static Color debit(Brightness b) => b == Brightness.dark ? debitDark : debitLight;
  static Color textMuted(Brightness b) =>
      b == Brightness.dark ? inkTextMutedDark : inkTextMutedLight;
  static Color border(Brightness b) => b == Brightness.dark ? inkBorderDark : inkBorderLight;
}

abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark ? AppColors.inkBackgroundDark : AppColors.inkBackgroundLight;
    final surface = isDark ? AppColors.inkSurfaceDark : AppColors.inkSurfaceLight;
    final onSurface = isDark ? AppColors.inkTextDark : AppColors.inkTextLight;
    final border = AppColors.border(brightness);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.amber,
      onPrimary: AppColors.onAmber,
      secondary: AppColors.amber,
      onSecondary: AppColors.onAmber,
      error: AppColors.debit(brightness),
      onError: isDark ? AppColors.inkBackgroundDark : Colors.white,
      surface: surface,
      onSurface: onSurface,
    );

    final textTheme = GoogleFonts.interTextTheme(
      isDark ? Typography.whiteMountainView : Typography.blackMountainView,
    ).apply(bodyColor: onSurface, displayColor: onSurface);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.amber,
        foregroundColor: AppColors.onAmber,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: AppColors.onAmber,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  /// Números tabulares (alinham em coluna) para valores monetários —
  /// confiança em dinheiro exige leitura exata, não estimada.
  static TextStyle money(TextStyle? base) => (base ?? const TextStyle()).copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontWeight: FontWeight.w600,
      );
}
