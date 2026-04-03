import 'package:flutter/material.dart';

/// Paleta de colores de Inventra.
///
/// Inspirada en estética administrativa moderna con púrpura profundo
/// como primario y teal como secundario. Identidad propia del producto.
abstract final class AppColors {
  // ─── Primarios ───
  static const primary = Color(0xFF6C5CE7);
  static const primaryLight = Color(0xFF8B7CF7);
  static const primaryDark = Color(0xFF5A4BD1);
  static const primarySurface = Color(0xFFF0EEFF);

  // ─── Secundarios ───
  static const secondary = Color(0xFF00B894);
  static const secondaryLight = Color(0xFF55EFC4);
  static const secondaryDark = Color(0xFF00A381);

  // ─── Acento ───
  static const accent = Color(0xFFFDCB6E);
  static const accentLight = Color(0xFFFFEAA7);
  static const accentDark = Color(0xFFF39C12);

  // ─── Peligro / Error ───
  static const danger = Color(0xFFE17055);
  static const dangerLight = Color(0xFFFF7675);
  static const dangerDark = Color(0xFFD63031);
  static const dangerSurface = Color(0xFFFFF0EE);

  // ─── Superficies ───
  static const surface = Color(0xFFF8F9FE);
  static const surfaceCard = Color(0xFFFFFFFF);
  static const surfaceHover = Color(0xFFF3F2FF);
  static const surfaceBorder = Color(0xFFE8E6F0);

  // ─── Sidebar ───
  static const sidebarBg = Color(0xFFF5F3FF);
  static const sidebarActive = Color(0xFF6C5CE7);
  static const sidebarHover = Color(0xFFEDE9FF);
  static const sidebarText = Color(0xFF636E72);
  static const sidebarTextActive = Color(0xFFFFFFFF);

  // ─── Texto ───
  static const textPrimary = Color(0xFF2D3436);
  static const textSecondary = Color(0xFF636E72);
  static const textTertiary = Color(0xFFB2BEC3);
  static const textOnPrimary = Color(0xFFFFFFFF);
  static const textOnDark = Color(0xFFF5F5F5);

  // ─── Gradientes ───
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6C5CE7), Color(0xFF8B7CF7)],
  );

  static const gradientSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
  );

  static const gradientDanger = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE17055), Color(0xFFFF7675)],
  );

  static const gradientAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFDCB6E), Color(0xFFFFEAA7)],
  );

  static const gradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D3436), Color(0xFF636E72)],
  );

  static const gradientSidebar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5F3FF), Color(0xFFFFFFFF)],
  );

  // ─── KPI Card backgrounds ───
  static const kpiPurple = Color(0xFF6C5CE7);
  static const kpiTeal = Color(0xFF00B894);
  static const kpiOrange = Color(0xFFE17055);
  static const kpiAmber = Color(0xFFFDCB6E);
}
