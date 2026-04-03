import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';
import '../domain/inventory_movement.dart';

/// Interfaz de datos con la colección temporal de inventarios.
class InventoryRepository {
  /// Obtiene todo el historial de movimientos atómicos resolviendo el cruce
  /// hacia la tabla de productos para tener siempre el nombre claro a mano.
  Future<List<InventoryMovement>> fetchMovements() async {
    try {
      final response = await SupabaseService.client
          .from('inventory_movements')
          .select('*, products(name, sku)')
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((json) => InventoryMovement.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Despacha un nuevo movimiento a la plataforma.
  /// Provoca error capturable (RAISE EXCEPTION) por el Trigger DB si 
  /// se excede el stock para una 'salida'.
  Future<InventoryMovement> addMovement({
    required String productId,
    required String movementType,
    required int quantity,
    String? reason,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('inventory_movements')
          .insert({
            'product_id': productId,
            'movement_type': movementType,
            'quantity': quantity,
            'reason': reason,
          })
          .select('*, products(name, sku)')
          .single();

      return InventoryMovement.fromJson(response);
    } on PostgrestException catch (pe) {
      // Si el Trigger en PostgreSQL frena la consulta, tirará un 
      // P0001 constraint custom exception con nuestro mensaje
      throw ErrorHandler.handle(pe, StackTrace.current);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }
}
