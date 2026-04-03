import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Galería de previews y plataformas de Inventra.
class LandingShowcase extends StatelessWidget {
  const LandingShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.xxxl : AppSpacing.lg,
        vertical: 80,
      ),
      color: AppColors.primary.withValues(alpha: 0.02),
      child: Column(
        children: [
          // Preview Placeholder
          Container(
            width: isDesktop ? 1000 : double.infinity,
            height: isDesktop ? 500 : 300,
            decoration: BoxDecoration(
              color: AppColors.surfaceBorder.withValues(alpha: 0.5),
              borderRadius: AppRadius.borderRadiusLg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.dashboard_customize_outlined, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  Text('Vista Previa del Panel Administrativo', style: AppTextStyles.titleMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 80),

          // Plataformas
          Text('Disponible para tu flujo de trabajo', style: AppTextStyles.titleLarge),
          const SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: const [
              _PlatformBadge(icon: Icons.window_rounded, label: 'Windows (EXE)'),
              _PlatformBadge(icon: Icons.android_rounded, label: 'Android (APK)'),
              _PlatformBadge(icon: Icons.language_rounded, label: 'Panel Web'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlatformBadge extends StatelessWidget {
  const _PlatformBadge({required this.icon, required this.label}); // Removido super.key
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
