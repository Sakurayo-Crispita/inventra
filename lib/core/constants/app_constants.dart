/// Constantes generales de la aplicación Inventra.
abstract final class AppConstants {
  static const String appName = 'Inventra';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Gestión de inventario inteligente';

  // ─── Animaciones ───
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ─── Paginación ───
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // ─── Validaciones ───
  static const int minPasswordLength = 6;
  static const int maxProductNameLength = 100;
  static const int maxCategoryNameLength = 50;
  static const int maxDescriptionLength = 500;
}
