import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/application/auth_provider.dart';
import '../../../users/application/users_provider.dart';
import '../widgets/dashboard_kpi_section.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/recent_activity_card.dart';

/// Pantalla principal del dashboard de Inventra.
///
/// Muestra saludo, KPIs, actividad reciente y accesos rápidos.
/// Layout adaptativo: dos columnas en desktop, columna única en mobile.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;
    
    // Obtener datos para el saludo
    final authState = ref.watch(authProvider);
    final profileAsync = ref.watch(currentProfileProvider);

    return Container(
      color: AppColors.surface,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? AppSpacing.xxxl : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Saludo ───
            profileAsync.when(
              data: (profile) {
                final baseGreeting = _getGreeting();
                String displayName = '';
                
                if (profile != null && profile.fullName.isNotEmpty) {
                  displayName = ', ${profile.fullName}!';
                } else if (authState.email != null) {
                  final emailPrefix = authState.email!.split('@').first;
                  displayName = ', $emailPrefix!';
                } else {
                  displayName = '!';
                }
                
                return Text(
                  '$baseGreeting$displayName',
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                );
              },
              loading: () => Text('${_getGreeting()}!', style: AppTextStyles.headingLarge),
              error: (_, __) => Text('${_getGreeting()}!', style: AppTextStyles.headingLarge),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Aquí tienes un resumen de tu inventario.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),

            // ─── KPI Cards ───
            const DashboardKpiSection(),
            const SizedBox(height: AppSpacing.xxxl),

            // ─── Contenido inferior ───
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actividad reciente (2/3)
                  const Expanded(
                    flex: 2,
                    child: RecentActivityCard(),
                  ),
                  const SizedBox(width: AppSpacing.xxl),
                  // Accesos rápidos (1/3)
                  const Expanded(
                    child: QuickActionsCard(),
                  ),
                ],
              )
            else
              const Column(
                children: [
                  RecentActivityCard(),
                  SizedBox(height: AppSpacing.lg),
                  QuickActionsCard(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días';
    if (hour < 18) return '¡Buenas tardes';
    return '¡Buenas noches';
  }
}
