import '../../../core/services/supabase_service.dart';
import '../domain/dashboard_stats.dart';

/// Repositorio del dashboard conectado a Supabase.
class DashboardRepository {
  /// Obtiene las estadísticas reales del dashboard.
  Future<DashboardStats> getStats() async {
    try {
      final client = SupabaseService.client;
      
      // 1. Total Productos (Activos)
      final productsRes = await client
          .from('products')
          .select('id')
          .eq('is_active', true);
      final totalProducts = (productsRes as List).length;

      // 2. Stock Bajo (current_stock < min_stock)
      final lowStockRes = await client
          .from('products')
          .select('current_stock, min_stock')
          .eq('is_active', true);
      
      final lowStockCount = (lowStockRes as List).where((p) {
        final current = p['current_stock'] as int? ?? 0;
        final min = p['min_stock'] as int? ?? 0;
        return current < min;
      }).length;

      // 3. Movimientos Hoy
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();
      final movementsRes = await client
          .from('inventory_movements')
          .select('id')
          .gte('created_at', todayStart);
      final todayMovements = (movementsRes as List).length;

      // 4. Categorías Activas
      final categoriesRes = await client
          .from('categories')
          .select('id')
          .eq('is_active', true);
      final activeCategories = (categoriesRes as List).length;

      return DashboardStats(
        totalProducts: totalProducts,
        lowStockCount: lowStockCount,
        todayMovements: todayMovements,
        activeCategories: activeCategories,
      );
    } catch (e) {
      return const DashboardStats(
        totalProducts: 0,
        lowStockCount: 0,
        todayMovements: 0,
        activeCategories: 0,
      );
    }
  }

  /// Obtiene la actividad reciente real (últimos 5 movimientos).
  Future<List<RecentActivity>> getRecentActivity() async {
    try {
      final client = SupabaseService.client;
      final response = await client
          .from('inventory_movements')
          .select('*, products(name)')
          .order('created_at', ascending: false)
          .limit(5);

      final movements = (response as List).map((json) {
        final type = json['movement_type'] == 'entrada' 
            ? ActivityType.stockIn 
            : ActivityType.stockOut;
        
        final createdAt = DateTime.parse(json['created_at']);
        final diff = DateTime.now().difference(createdAt);
        
        String timeAgo;
        if (diff.inMinutes < 1) {
          timeAgo = 'Ahora';
        } else if (diff.inMinutes < 60) {
          timeAgo = 'Hace ${diff.inMinutes} min';
        } else if (diff.inHours < 24) {
          timeAgo = 'Hace ${diff.inHours} h';
        } else {
          timeAgo = 'Hace ${diff.inDays} d';
        }

        return RecentActivity(
          description: type == ActivityType.stockIn 
              ? 'Entrada de stock registrada' 
              : 'Salida de stock registrada',
          type: type,
          timeAgo: timeAgo,
          productName: json['products']?['name'],
        );
      }).toList();

      return movements;
    } catch (e) {
      return [];
    }
  }
}
