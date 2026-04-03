
import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';

/// Repositorio de autenticación para Inventra.
///
/// Encapsula todas las operaciones de auth contra Supabase.
/// Los providers consumen este repositorio, nunca acceden al SDK directo.
class AuthRepository {
  /// Inicia sesión con email y contraseña.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await SupabaseService.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Cierra la sesión actual.
  Future<void> signOut() async {
    try {
      await SupabaseService.auth.signOut();
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Envía un email de recuperación de contraseña.
  Future<void> resetPassword(String email) async {
    try {
      await SupabaseService.auth.resetPasswordForEmail(email);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Verifica si hay una sesión activa.
  bool get isAuthenticated => SupabaseService.hasSession;

  /// Obtiene el email del usuario actual.
  String? get currentEmail => SupabaseService.currentUser?.email;

  /// Obtiene el ID del usuario actual.
  String? get currentUserId => SupabaseService.currentUserId;
}
