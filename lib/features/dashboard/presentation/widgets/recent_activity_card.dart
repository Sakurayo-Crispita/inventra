import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../application/dashboard_provider.dart';
import '../../domain/dashboard_stats.dart';

/// Tarjeta de actividad reciente del dashboard.
///
/// Lista los últimos movimientos y cambios del sistema.
class RecentActivityCard extends ConsumerWidget {
  const RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(recentActivityProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Actividad Reciente',
                style: AppTextStyles.titleMedium,
              ),
              TextButton(
                onPressed: () => context.goNamed(RouteNames.inventory),
                child: const Text('Ver todo'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ─── Lista ───
          activityAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text('Error al cargar actividad: $e'),
            ),
            data: (activities) => Column(
              children: activities.map((activity) {
                return _ActivityItem(activity: activity);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.activity});

  final RecentActivity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          // ─── Icono ───
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _getColor().withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusSm,
            ),
            child: Icon(
              _getIcon(),
              size: 18,
              color: _getColor(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // ─── Contenido ───
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (activity.productName != null)
                  Text(
                    activity.productName!,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // ─── Tiempo ───
          Text(
            activity.timeAgo,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    return switch (activity.type) {
      ActivityType.stockIn => AppColors.secondary,
      ActivityType.stockOut => AppColors.danger,
      ActivityType.productCreated => AppColors.primary,
      ActivityType.categoryUpdated => AppColors.accent,
    };
  }

  IconData _getIcon() {
    return switch (activity.type) {
      ActivityType.stockIn => Icons.arrow_downward_rounded,
      ActivityType.stockOut => Icons.arrow_upward_rounded,
      ActivityType.productCreated => Icons.add_box_outlined,
      ActivityType.categoryUpdated => Icons.edit_outlined,
    };
  }
}
