import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../data/category_repository.dart';
import '../domain/category.dart';

/// Provider expuesto del Repositorio de Categorías.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

/// Provider controlador del listado de Categorías.
///
/// Gestiona la recuperación, creación, edición y apagado lógico,
/// y expone la vista reactiva (Loading/Data/Error).
final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<Category>>(
  CategoriesNotifier.new,
);

class CategoriesNotifier extends AsyncNotifier<List<Category>> {
  late CategoryRepository _repository;

  @override
  FutureOr<List<Category>> build() async {
    _repository = ref.read(categoryRepositoryProvider);
    return _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    return _repository.fetchCategories();
  }

  /// Refresca la lista desde el servidor.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchCategories);
  }

  /// Crea una nueva categoría y actualiza el estado.
  Future<void> addCategory({
    required String name,
    String? description,
  }) async {
    // Si ya estamos asumiendo errores, evitamos mutar estado base, pero queremos
    // interactuar localmente. La forma más segura:
    try {
      final newCat = await _repository.createCategory(
        name: name,
        description: description,
      );
      
      // Actualizamos listado
      if (state.hasValue) {
        state = AsyncData([...?state.value, newCat]);
      }
    } on AppException {
      rethrow;
    }
  }

  /// Editamos una categoría en la BD y actualizamos estado local
  Future<void> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    try {
      final updatedCat = await _repository.updateCategory(
        id: id,
        name: name,
        description: description,
      );

      // Reemplazamos en memoria
      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncData([
          for (final cat in currentList)
            if (cat.id == id) updatedCat else cat
        ]);
      }
    } on AppException {
      rethrow;
    }
  }

  /// Intercambia el estado activo/inactivo (Borrado lógico)
  Future<void> toggleStatus(String id, bool newStatus) async {
    try {
      final updatedCat = await _repository.toggleCategoryStatus(id, newStatus);
      
      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncData([
          for (final cat in currentList)
            if (cat.id == id) updatedCat else cat
        ]);
      }
    } on AppException {
      rethrow;
    }
  }
}
