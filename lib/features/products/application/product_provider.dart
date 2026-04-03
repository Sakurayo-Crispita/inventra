import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../data/product_repository.dart';
import '../domain/product.dart';

/// Provider expuesto del Repositorio de Productos.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Provider controlador del listado de Productos.
///
/// Gestiona asíncronamente el estado de todos los productos y provee métodos
/// transparentes para sus mutaciones hacia el repositorio.
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  late ProductRepository _repository;

  @override
  FutureOr<List<Product>> build() async {
    _repository = ref.read(productRepositoryProvider);
    return _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    return _repository.fetchProducts();
  }

  /// Refresca la lista desde el servidor.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchProducts);
  }

  /// Añade producto interceptando fallos o inyectando el resultado en local
  Future<void> addProduct({
    required String name,
    required String sku,
    required String categoryId,
    String? description,
    required int minStock,
    String? imageUrl,
  }) async {
    try {
      final newProd = await _repository.createProduct(
        name: name,
        sku: sku,
        categoryId: categoryId,
        description: description,
        minStock: minStock,
        imageUrl: imageUrl,
      );
      
      if (state.hasValue) {
        state = AsyncData([...?state.value, newProd]);
      }
    } on AppException {
      rethrow;
    }
  }

  /// Edita y desplaza in-memory state del producto actualizado
  Future<void> updateProduct({
    required String id,
    required String name,
    required String sku,
    required String categoryId,
    String? description,
    required int minStock,
    String? imageUrl,
  }) async {
    try {
      final updatedProd = await _repository.updateProduct(
        id: id,
        name: name,
        sku: sku,
        categoryId: categoryId,
        description: description,
        minStock: minStock,
        imageUrl: imageUrl,
      );

      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncData([
          for (final prod in currentList)
            if (prod.id == id) updatedProd else prod
        ]);
      }
    } on AppException {
      rethrow;
    }
  }

  /// Actualiza status de borrado lógico
  Future<void> toggleStatus(String id, bool newStatus) async {
    try {
      final updatedProd = await _repository.toggleProductStatus(id, newStatus);
      
      if (state.hasValue) {
        final currentList = state.value!;
        state = AsyncData([
          for (final prod in currentList)
            if (prod.id == id) updatedProd else prod
        ]);
      }
    } on AppException {
      rethrow;
    }
  }
}
