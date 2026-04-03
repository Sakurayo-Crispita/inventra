import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';
import '../domain/category.dart';

/// Repositorio de la capa de datos para Categorías.
///
/// Se comunica con Supabase e intercepta errores retornando [Category].
class CategoryRepository {
  /// Obtiene todas las categorías (ordenadas por nombre).
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await SupabaseService.client
          .from('categories')
          .select()
          .order('name');
          
      return (response as List<dynamic>)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Crea una nueva categoría.
  Future<Category> createCategory({
    required String name,
    String? description,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('categories')
          .insert({
            'name': name,
            'description': description,
            'is_active': true,
          })
          .select()
          .single();
          
      return Category.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Actualiza una categoría existente.
  Future<Category> updateCategory({
    required String id,
    required String name,
    String? description,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('categories')
          .update({
            'name': name,
            'description': description,
          })
          .eq('id', id)
          .select()
          .single();
          
      return Category.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Cambia el estado de [isActive] (Borrado lógico).
  Future<Category> toggleCategoryStatus(String id, bool isActive) async {
    try {
      final response = await SupabaseService.client
          .from('categories')
          .update({
            'is_active': isActive,
          })
          .eq('id', id)
          .select()
          .single();
          
      return Category.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }
}
