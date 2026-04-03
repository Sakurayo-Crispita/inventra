import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/application/auth_provider.dart';
import '../data/user_repository.dart';
import '../domain/user_profile.dart';

/// Provider expuesto del Repositorio de Usuarios.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// Provider que obtiene el perfil del usuario actualmente autenticado.
final currentProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final authState = ref.watch(authProvider);
  final userId = authState.userId;
  
  if (userId == null) return null;
  
  try {
    return await ref.read(userRepositoryProvider).fetchProfileById(userId);
  } catch (_) {
    return null;
  }
});

/// Provider controlador de la lista de perfiles administrativos.
///
/// Refleja de forma síncrona/asíncrona la grilla de usuarios en el sistema.
final usersProvider = AsyncNotifierProvider<UsersNotifier, List<UserProfile>>(
  UsersNotifier.new,
);

class UsersNotifier extends AsyncNotifier<List<UserProfile>> {
  late UserRepository _repository;

  @override
  FutureOr<List<UserProfile>> build() async {
    _repository = ref.read(userRepositoryProvider);
    return _fetchProfiles();
  }

  Future<List<UserProfile>> _fetchProfiles() async {
    return _repository.fetchProfiles();
  }

  /// Activa o desactiva a un usuario.
  Future<void> toggleUserStatus(String id, bool newStatus) async {
    try {
      final updatedUser = await _repository.updateProfile(id, isActive: newStatus);

      // Mutación in-memory de la caché del listado
      if (state.hasValue) {
        state = AsyncData(
          state.value!.map((u) => u.id == id ? updatedUser : u).toList(),
        );
      }
    } on AppException {
      rethrow;
    }
  }

  /// Actualiza el rol de un usuario.
  Future<void> updateUserRole(String id, UserRole newRole) async {
    try {
      final updatedUser = await _repository.updateProfile(id, role: newRole.value);

      // Mutación in-memory
      if (state.hasValue) {
        state = AsyncData(
          state.value!.map((u) => u.id == id ? updatedUser : u).toList(),
        );
      }
    } on AppException {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProfiles);
  }
}
