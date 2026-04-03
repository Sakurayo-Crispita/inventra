/// Tipos de excepción de la aplicación Inventra.
///
/// Clasificación centralizada de errores para manejo uniforme.
sealed class AppException implements Exception {
  const AppException(this.message, {this.originalError});

  final String message;
  final Object? originalError;

  @override
  String toString() => 'AppException: $message';
}

/// Error de red (sin conexión, timeout).
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Error de conexión. Verifica tu red.',
  ]);
}

/// Error de autenticación (sesión expirada, credenciales inválidas).
class AuthException extends AppException {
  const AuthException([
    super.message = 'Error de autenticación.',
  ]);
}

/// Error de permisos (acceso denegado por rol).
class PermissionException extends AppException {
  const PermissionException([
    super.message = 'No tienes permisos para esta acción.',
  ]);
}

/// Error de validación (datos inválidos del formulario).
class ValidationException extends AppException {
  const ValidationException([
    super.message = 'Los datos ingresados no son válidos.',
  ]);
}

/// Error de negocio (stock insuficiente, reglas internas).
class BusinessException extends AppException {
  const BusinessException([
    super.message = 'Error de negocio.',
  ]);
}

/// Error inesperado (fallback).
class UnexpectedException extends AppException {
  const UnexpectedException([
    super.message = 'Ocurrió un error inesperado.',
  ]);
}
