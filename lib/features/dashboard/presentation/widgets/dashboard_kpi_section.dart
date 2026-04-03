import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/kpi_card.dart';
import '../../application/dashboard_provider.dart';

/// Sección de tarjetas KPI del dashboard.
///
/// Grid de 4 tarjetas con gradientes de colores inspirados en
/// el diseño de referencia. Incluye loading shimmer y error state.
class DashboardKpiSection extends ConsumerWidget {
  const DashboardKpiSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Grid: 1 col mobile, 2 col tablet, 4 col desktop
    final crossAxisCount = screenWidth >= AppSpacing.breakpointDesktop
        ? 4
        : screenWidth >= AppSpacing.breakpointMobile
            ? 2
            : 1;

    return statsAsync.when(
      loading: () => _buildShimmer(crossAxisCount),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Text('Error al cargar estadísticas: $e'),
        ),
      ),
      data: (stats) => GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          mainAxisExtent: 190, // Altura fija que previene overflows
        ),
        children: [
          KpiCard(
            title: 'Total Productos',
            value: stats.totalProducts.toString(),
            icon: Icons.inventory_2_rounded,
            gradient: AppColors.gradientPrimary,
            trend: const KpiTrend(label: '+12%', isPositive: true),
            subtitle: 'vs. mes anterior',
          ),
          KpiCard(
            title: 'Stock Bajo',
            value: stats.lowStockCount.toString(),
            icon: Icons.warning_amber_rounded,
            gradient: AppColors.gradientDanger,
            trend: const KpiTrend(label: '-3', isPositive: true),
            subtitle: 'necesitan atención',
          ),
          KpiCard(
            title: 'Movimientos Hoy',
            value: stats.todayMovements.toString(),
            icon: Icons.swap_vert_rounded,
            gradient: AppColors.gradientSecondary,
            trend: const KpiTrend(label: '+8', isPositive: true),
            subtitle: 'entradas y salidas',
          ),
          KpiCard(
            title: 'Categorías Activas',
            value: stats.activeCategories.toString(),
            icon: Icons.category_rounded,
            gradient: AppColors.gradientAccent,
            subtitle: 'organizando productos',
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(int crossAxisCount) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceBorder,
      highlightColor: AppColors.surface,
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
          mainAxisExtent: 190,
        ),
        children: List.generate(
          4,
          (_) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.borderRadiusLg,
            ),
          ),
        ),
      ),
    );
  }
}
