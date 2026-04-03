/// Estadísticas del dashboard de Inventra.
///
/// Modelo inmutable para las métricas principales.
class DashboardStats {
  const DashboardStats({
    required this.totalProducts,
    required this.lowStockCount,
    required this.todayMovements,
    required this.activeCategories,
  });

  final int totalProducts;
  final int lowStockCount;
  final int todayMovements;
  final int activeCategories;

  /// Datos de ejemplo para el dashboard inicial.
  static const mock = DashboardStats(
    totalProducts: 156,
    lowStockCount: 12,
    todayMovements: 34,
    activeCategories: 8,
  );
}

/// Actividad reciente del dashboard.
class RecentActivity {
  const RecentActivity({
    required this.description,
    required this.type,
    required this.timeAgo,
    this.productName,
  });

  final String description;
  final ActivityType type;
  final String timeAgo;
  final String? productName;

  static const mockActivities = [
    RecentActivity(
      description: 'Entrada de stock registrada',
      type: ActivityType.stockIn,
      timeAgo: 'Hace 5 min',
      productName: 'Laptop HP ProBook 450',
    ),
    RecentActivity(
      description: 'Salida de stock registrada',
      type: ActivityType.stockOut,
      timeAgo: 'Hace 15 min',
      productName: 'Teclado mecánico Logitech',
    ),
    RecentActivity(
      description: 'Producto creado',
      type: ActivityType.productCreated,
      timeAgo: 'Hace 1 hora',
      productName: 'Monitor Dell 27"',
    ),
    RecentActivity(
      description: 'Categoría actualizada',
      type: ActivityType.categoryUpdated,
      timeAgo: 'Hace 2 horas',
      productName: 'Electrónicos',
    ),
    RecentActivity(
      description: 'Entrada de stock registrada',
      type: ActivityType.stockIn,
      timeAgo: 'Hace 3 horas',
      productName: 'Mouse inalámbrico',
    ),
  ];
}

enum ActivityType {
  stockIn,
  stockOut,
  productCreated,
  categoryUpdated,
}
