import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Sección Hero de la Landing.
///
/// Presenta la propuesta de valor principal de Inventra.
class LandingHero extends StatelessWidget {
  const LandingHero({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? AppSpacing.xxxl : AppSpacing.lg,
          vertical: isDesktop ? 120 : 60,
        ),
        child: Column(
          crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'MVP ADMINISTRATIVO LISTO',
                style: AppTextStyles.overline.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Título
            SizedBox(
              width: isDesktop ? 800 : null,
              child: Text(
                'Control Total de tu Inventario, en cualquier lugar.',
                textAlign: isDesktop ? TextAlign.center : TextAlign.left,
                style: isDesktop ? AppTextStyles.displayMedium : AppTextStyles.headingLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Subtítulo
            SizedBox(
              width: isDesktop ? 600 : null,
              child: Text(
                'La solución administrativa moderna y avanzada para gestionar productos, stock, equipos y movimientos con precisión quirúrgica.',
                textAlign: isDesktop ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // CTAs
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.md,
              children: [
                ElevatedButton.icon(
                  onPressed: () => launchUrl(Uri.parse(AppConstants.webPanelUrl)),
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Comenzar Gratis'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => launchUrl(Uri.parse(AppConstants.webPanelUrl)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Ver Demo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
