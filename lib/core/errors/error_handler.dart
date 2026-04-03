import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Manejador centralizado de errores para Inventra.
///
/// Convierte excepciones brutas en AppException clasificadas
/// y proporciona mensajes útiles para el usuario.
abstract final class ErrorHandler {
  /// Convierte una excepción genérica en una [AppException] clasificada.
  static AppException handle(Object error, [StackTrace? stackTrace]) {
    // Log en desarrollo, nunca imprimir tokens o datos sensibles
    if (kDebugMode) {
      debugPrint('─── Error Handler ───');
      debugPrint('Error: ${error.runtimeType}');
      debugPrint('Message: $error');
      if (stackTrace != null) {
        debugPrint('Stack: ${stackTrace.toString().split('\n').take(5).join('\n')}');
      }
      debugPrint('─────────────────────');
    }

    if (error is AppException) return error;

    final errorString = error.toString().toLowerCase();

    // Errores de Base de Datos (Supabase / Postgrest)
    // Especialmente útil para capturar excepciones de Triggers (P0001)
    if (errorString.contains('postgrestexception') || errorString.contains('p0001')) {
      // Intentar extraer el mensaje de error de la excepción de negocio (Trigger)
      if (errorString.contains('insuficiente') || errorString.contains('min_stock')) {
        // Si el mensaje viene del Trigger de stock, lo limpiamos un poco
        final cleanMsg = error.toString()
            .split(':')
            .last
            .replaceAll('"', '')
            .replaceAll('{', '')
            .replaceAll('}', '')
            .trim();
        return BusinessException(cleanMsg);
      }
      
      if (errorString.contains('permission') || errorString.contains('forbidden')) {
        return const PermissionException('No tienes permisos en la base de datos.');
      }
    }

    // Errores de red
    if (errorString.contains('socketexception') ||
        errorString.contains('timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network')) {
      return const NetworkException(
        'Error de conexión. Verifica tu red e inténtalo de nuevo.',
      );
    }

    // Errores de autenticación
    if (errorString.contains('auth') ||
        errorString.contains('unauthorized') ||
        errorString.contains('invalid login') ||
        errorString.contains('invalid_credentials')) {
      return const AuthException(
        'Credenciales incorrectas o sesión expirada.',
      );
    }

    // Errores de permisos genéricos
    if (errorString.contains('permission') ||
        errorString.contains('forbidden') ||
        errorString.contains('rls') ||
        errorString.contains('policy')) {
      return const PermissionException(
        'No tienes permisos para realizar esta acción.',
      );
    }

    return const UnexpectedException(
      'Ocurrió un error inesperado al procesar la solicitud.',
    );
  }

  /// Mensaje amigable para el usuario según el tipo de error.
  static String userMessage(AppException exception) {
    return exception.message;
  }
}
