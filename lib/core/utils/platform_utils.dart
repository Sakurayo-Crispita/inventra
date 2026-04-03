import 'package:flutter/foundation.dart';

/// Utilidades para detección de plataforma.
abstract final class PlatformUtils {
  /// Verdadero si es escritorio (Windows, macOS, Linux).
  static bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.linux;

  /// Verdadero si es móvil (Android, iOS).
  static bool get isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Verdadero si es Windows.
  static bool get isWindows =>
      defaultTargetPlatform == TargetPlatform.windows;

  /// Verdadero si es Android.
  static bool get isAndroid =>
      defaultTargetPlatform == TargetPlatform.android;
}
