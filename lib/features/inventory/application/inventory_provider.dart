import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../products/application/product_provider.dart';
import '../data/inventory_repository.dart';
import '../domain/inventory_movement.dart';

/// Provider expuesto del Repositorio de Inventario.
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository();
});

/// Provider controlador del listado de Movimientos.
///
/// Refleja de forma síncrona/asíncrona la grilla de acciones ejecutadas.
final inventoryProvider =
    AsyncNotifierProvider<InventoryNotifier, List<InventoryMovement>>(
  InventoryNotifier.new,
);

class InventoryNotifier extends AsyncNotifier<List<InventoryMovement>> {
  late InventoryRepository _repository;

  @override
  FutureOr<List<InventoryMovement>> build() async {
    _repository = ref.read(inventoryRepositoryProvider);
    return _fetchMovements();
  }

  Future<List<InventoryMovement>> _fetchMovements() async {
    return _repository.fetchMovements();
  }

  /// Despacha una transacción de entrada o salida hacia la base.
  /// Llama asíncronamente a los proveedores complementarios para forzar
  /// un repintado de las existencias actuales de las tarjetas sin delay.
  Future<void> addMovement({
    required String productId,
    required String movementType,
    required int quantity,
    String? reason,
  }) async {
    try {
      final newMovement = await _repository.addMovement(
        productId: productId,
        movementType: movementType,
        quantity: quantity,
        reason: reason,
      );

      // 1. Modificar cache in-memory del historial
      if (state.hasValue) {
        state = AsyncData([newMovement, ...?state.value]);
      } else {
        state = AsyncData([newMovement]);
      }

      // 2. Refrescar silenciosamente el provider de Productos
      // dado que el Trigger atómico (Backend) acaba de mutar el stock total.
      ref.read(productsProvider.notifier).refresh();
      
    } on AppException {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchMovements);
  }
}
