import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/supabase_constants.dart';

/// Wrapper del cliente Supabase para Inventra.
///
/// Centraliza el acceso al SDK para que si cambia la implementación,
/// no se rompa toda la app. Todos los datasources deben usar este
/// servicio en lugar de acceder a Supabase directamente.
abstract final class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  static GoTrueClient get auth => client.auth;

  static SupabaseStorageClient get storage => client.storage;

  /// Inicializa Supabase. Debe llamarse antes de runApp().
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.url,
      anonKey: SupabaseConstants.anonKey,
    );
  }

  /// Verifica si hay una sesión activa.
  static bool get hasSession => auth.currentSession != null;

  /// Obtiene el usuario actual, si existe.
  static User? get currentUser => auth.currentUser;

  /// Obtiene el ID del usuario actual.
  static String? get currentUserId => currentUser?.id;
}
