import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/dashboard_repository.dart';
import '../domain/dashboard_stats.dart';

/// Provider del repositorio del dashboard.
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

/// Provider de las estadísticas del dashboard.
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final repository = ref.read(dashboardRepositoryProvider);
  return repository.getStats();
});

/// Provider de la actividad reciente.
final recentActivityProvider = FutureProvider<List<RecentActivity>>((ref) async {
  final repository = ref.read(dashboardRepositoryProvider);
  return repository.getRecentActivity();
});
