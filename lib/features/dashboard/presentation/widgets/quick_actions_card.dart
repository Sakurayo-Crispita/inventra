import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Tarjeta de accesos rápidos del dashboard.
///
/// Botones para acciones frecuentes: nuevo producto, nuevo movimiento, etc.
class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Accesos Rápidos',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          _QuickAction(
            icon: Icons.add_box_outlined,
            label: 'Nuevo Producto',
            color: AppColors.primary,
            onTap: () => context.goNamed(
              RouteNames.products,
              queryParameters: {'action': 'new'},
            ),
          ),
          _QuickAction(
            icon: Icons.arrow_downward_rounded,
            label: 'Registrar Entrada',
            color: AppColors.secondary,
            onTap: () => context.goNamed(
              RouteNames.inventory,
              queryParameters: {'action': 'entry'},
            ),
          ),
          _QuickAction(
            icon: Icons.arrow_upward_rounded,
            label: 'Registrar Salida',
            color: AppColors.danger,
            onTap: () => context.goNamed(
              RouteNames.inventory,
              queryParameters: {'action': 'exit'},
            ),
          ),
          _QuickAction(
            icon: Icons.category_outlined,
            label: 'Nueva Categoría',
            color: AppColors.accent,
            onTap: () => context.goNamed(
              RouteNames.categories,
              queryParameters: {'action': 'new'},
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: AppRadius.borderRadiusSm,
            border: Border.all(
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.3)
                  : AppColors.surfaceBorder,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderRadiusSm,
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: widget.color,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                widget.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
