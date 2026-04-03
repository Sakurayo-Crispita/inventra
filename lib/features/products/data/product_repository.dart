import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';
import '../domain/product.dart';

/// Repositorio de la capa de datos para Products.
///
/// Se comunica con Supabase e intercepta errores retornando [Product].
class ProductRepository {
  /// Obtiene todos los productos anexando el cruce (JOIN) limitativo 
  /// sobre el nombre de la tabla categorías.
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await SupabaseService.client
          .from('products')
          .select('*, categories(name)')
          .order('name');
          
      return (response as List<dynamic>)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Crea un nuevo producto.
  Future<Product> createProduct({
    required String name,
    required String sku,
    required String categoryId,
    String? description,
    required int minStock,
    String? imageUrl,
  }) async {
    try {
      // Usamos el mismo select para obtener la representación completa con Join
      final response = await SupabaseService.client
          .from('products')
          .insert({
            'name': name,
            'sku': sku,
            'category_id': categoryId,
            'description': description,
            'min_stock': minStock,
            'image_url': imageUrl,
            'is_active': true,
          })
          .select('*, categories(name)')
          .single();
          
      return Product.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Actualiza un producto existente.
  Future<Product> updateProduct({
    required String id,
    required String name,
    required String sku,
    required String categoryId,
    String? description,
    required int minStock,
    String? imageUrl,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('products')
          .update({
            'name': name,
            'sku': sku,
            'category_id': categoryId,
            'description': description,
            'min_stock': minStock,
            'image_url': imageUrl,
          })
          .eq('id', id)
          .select('*, categories(name)')
          .single();
          
      return Product.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Cambia el estado de [isActive] (Borrado lógico).
  Future<Product> toggleProductStatus(String id, bool isActive) async {
    try {
      final response = await SupabaseService.client
          .from('products')
          .update({
            'is_active': isActive,
          })
          .eq('id', id)
          .select('*, categories(name)')
          .single();
          
      return Product.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }
}
