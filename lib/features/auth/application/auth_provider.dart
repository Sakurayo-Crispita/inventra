import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';

/// Provider del repositorio de autenticación.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

/// Provider del estado de autenticación.
///
/// Maneja login, logout y escucha cambios de sesión de Supabase.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

/// Notifier que gestiona el estado de autenticación.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(AuthState.initial) {
    _initialize();
  }

  final AuthRepository _repository;

  void _initialize() {
    // Verificar sesión actual
    if (_repository.isAuthenticated) {
      state = AuthState(
        isAuthenticated: true,
        email: _repository.currentEmail,
        userId: _repository.currentUserId,
      );
    }

    // Escuchar cambios de sesión
    SupabaseService.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      switch (event) {
        case sb.AuthChangeEvent.signedIn:
        case sb.AuthChangeEvent.tokenRefreshed:
          state = AuthState(
            isAuthenticated: true,
            email: session?.user.email,
            userId: session?.user.id,
          );
          break;
        case sb.AuthChangeEvent.signedOut:
          state = AuthState.initial;
          break;
        default:
          break;
      }
    });
  }

  /// Inicia sesión con email y contraseña.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _repository.signIn(email: email, password: password);
      // El listener de onAuthStateChange actualiza el estado
    } on AppException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e, stack) {
      final handled = ErrorHandler.handle(e, stack);
      state = state.copyWith(
        isLoading: false,
        errorMessage: handled.message,
      );
    }
  }

  /// Cierra la sesión.
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.signOut();
    } catch (e) {
      // Aún así cerrar localmente
      state = AuthState.initial;
    }
  }

  /// Limpia el mensaje de error.
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
