/// Modelo de dominio para un Movimiento de Inventario.
///
/// Refleja un historial atómico de un ingreso o egreso de la base de datos.
class InventoryMovement {
  const InventoryMovement({
    required this.id,
    required this.productId,
    required this.movementType,
    required this.quantity,
    this.reason,
    required this.createdAt,
    this.productName,
    this.productSku,
  });

  final String id;
  final String productId;
  final String movementType; // 'entrada' o 'salida'
  final int quantity;
  final String? reason;
  final DateTime createdAt;

  /// Campos auxiliares inyectados opcionalmente cuando se agrupa
  /// mediante `select('*, products(name, sku)')`
  final String? productName;
  final String? productSku;

  bool get isEntry => movementType == 'entrada';

  factory InventoryMovement.fromJson(Map<String, dynamic> json) {
    String? resolvedName;
    String? resolvedSku;
    
    if (json['products'] != null && json['products'] is Map) {
      final pMap = json['products'] as Map<String, dynamic>;
      resolvedName = pMap['name'] as String?;
      resolvedSku = pMap['sku'] as String?;
    }

    return InventoryMovement(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      movementType: json['movement_type'] as String,
      quantity: json['quantity'] as int,
      reason: json['reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      productName: resolvedName,
      productSku: resolvedSku,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'product_id': productId,
      'movement_type': movementType,
      'quantity': quantity,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
    };
  }
}
