import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/application/auth_provider.dart';
import '../../../dashboard/application/dashboard_provider.dart';

/// Header superior del panel administrativo.
///
/// Muestra título de sección, barra de búsqueda y menú de usuario.
class AppHeader extends ConsumerWidget {
  const AppHeader({
    super.key,
    required this.title,
    this.onMenuTap,
    this.showMenuButton = false,
  });

  final String title;
  final VoidCallback? onMenuTap;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          bottom: BorderSide(
            color: AppColors.surfaceBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // ─── Menu button (mobile) ───
          if (showMenuButton)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Menú',
              ),
            ),

          // ─── Título ───
          Text(
            title,
            style: AppTextStyles.headingMedium,
          ),

          const Spacer(),

          // ─── Búsqueda (solo desktop) ───
          if (MediaQuery.sizeOf(context).width >= AppSpacing.breakpointTablet)
            Container(
              width: 260,
              height: 40,
              margin: const EdgeInsets.only(right: AppSpacing.lg),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    borderSide: BorderSide(
                      color: AppColors.surfaceBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    borderSide: BorderSide(
                      color: AppColors.surfaceBorder,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),

          // ─── Notificaciones ───
          _NotificationBell(),
          const SizedBox(width: AppSpacing.sm),

          // ─── Avatar / User menu ───
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Administrador',
                      style: AppTextStyles.labelLarge,
                    ),
                    Text(
                      authState.email ?? 'usuario@inventra.com',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 18),
                    SizedBox(width: 8),
                    Text('Mi perfil'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18, color: AppColors.danger),
                    SizedBox(width: 8),
                    Text('Cerrar sesión', style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ],
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primarySurface.withValues(alpha: 0.1),
                  child: Text(
                    _getInitials(authState.email),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (MediaQuery.sizeOf(context).width >= AppSpacing.breakpointTablet) ...[
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String? email) {
    if (email == null || email.isEmpty) return 'U';
    return email[0].toUpperCase();
  }
}

class _NotificationBell extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(recentActivityProvider);

    return PopupMenuButton<void>(
      offset: const Offset(0, 50),
      tooltip: 'Notificaciones',
      icon: Badge(
        smallSize: 8,
        isLabelVisible: activityAsync.when(
          data: (data) => data.isNotEmpty,
          loading: () => false,
          error: (_, __) => false,
        ),
        child: const Icon(Icons.notifications_outlined),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            'Actividad reciente',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
          ),
        ),
        const PopupMenuDivider(),
        ...activityAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return [
                PopupMenuItem(
                  enabled: false,
                  child: Text('No hay notificaciones', style: AppTextStyles.caption),
                ),
              ];
            }
            return activities.take(3).map((activity) {
              return PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activity.description,
                      style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (activity.productName != null)
                      Text(activity.productName!, style: AppTextStyles.caption),
                    Text(activity.timeAgo, style: AppTextStyles.overline),
                  ],
                ),
              );
            }).toList();
          },
          loading: () => [
            const PopupMenuItem(
              enabled: false,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ],
          error: (_, __) => [
            const PopupMenuItem(
              enabled: false,
              child: Text('Error al cargar'),
            ),
          ],
        ),
      ],
    );
  }
}
