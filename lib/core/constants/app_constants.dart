/// Constantes generales de la aplicación Inventra.
abstract final class AppConstants {
  static const String appName = 'Inventra';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Gestión de inventario avanzada';

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

  // ─── GitHub & Despliegue ───
  static const String githubRepo = 'https://github.com/Sakurayo-Crispita/inventra';
  static const String webPanelUrl = 'https://Sakurayo-Crispita.github.io/inventra/';
  static const String androidDownloadUrl = '$githubRepo/releases/latest/download/app-release.apk';
  static const String windowsDownloadUrl = '$githubRepo/releases/latest/download/windows-release.zip';
}
