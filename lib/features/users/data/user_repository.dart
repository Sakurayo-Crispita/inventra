
import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';
import '../domain/user_profile.dart';

/// Repositorio de perfiles administrativos.
///
/// Gestiona la lectura y actualización de roles y estados en `public.profiles`.
class UserRepository {
  /// Obtiene todos los perfiles registrados en la base pública.
  Future<List<UserProfile>> fetchProfiles() async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select('*')
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => UserProfile.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Obtiene un perfil por ID.
  Future<UserProfile> fetchProfileById(String id) async {
    try {
      final response = await SupabaseService.client
          .from('profiles')
          .select('*')
          .eq('id', id)
          .single();

      return UserProfile.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Actualiza un perfil específico.
  Future<UserProfile> updateProfile(
    String id, {
    String? fullName,
    String? role,
    bool? isActive,
  }) async {
    try {
      final updates = <String, dynamic>{
        if (fullName != null) 'full_name': fullName,
        if (role != null) 'role': role,
        if (isActive != null) 'is_active': isActive,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      final response = await SupabaseService.client
          .from('profiles')
          .update(updates)
          .eq('id', id)
          .select('*')
          .single();

      return UserProfile.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }
}
