/// Modelo de dominio para los Productos.
///
/// Representa un artículo físico o servicio en el inventario.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.categoryId,
    this.description,
    required this.minStock,
    required this.currentStock,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
  });

  final String id;
  final String name;
  final String sku;
  final String categoryId;
  final String? description;
  final int minStock;
  final int currentStock;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Campo auxiliar resuelto por JOIN SQL. Retiene el nombre
  /// de la categoría asociada para renderizado rápido.
  final String? categoryName;

  /// Crea una instancia desde un mapa (JSON) recibido de Supabase
  factory Product.fromJson(Map<String, dynamic> json) {
    // Supabase resuelve joins como maps dentro del json principal.
    String? resolvedCatName;
    if (json['categories'] != null && json['categories'] is Map) {
      resolvedCatName = json['categories']['name'] as String?;
    }

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      categoryId: json['category_id'] as String,
      description: json['description'] as String?,
      minStock: json['min_stock'] as int? ?? 0,
      currentStock: json['current_stock'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      categoryName: resolvedCatName,
    );
  }

  /// Convierte la instancia a un mapa JSON para enviar a Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'sku': sku,
      'category_id': categoryId,
      if (description != null) 'description': description,
      'min_stock': minStock,
      'current_stock': currentStock,
      if (imageUrl != null) 'image_url': imageUrl,
      'is_active': isActive,
    };
  }

  /// Crea una copia del producto con campos actualizados
  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? categoryId,
    String? description,
    int? minStock,
    int? currentStock,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryName,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      minStock: minStock ?? this.minStock,
      currentStock: currentStock ?? this.currentStock,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}
