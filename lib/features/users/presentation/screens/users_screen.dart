import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../application/users_provider.dart';
import '../../domain/user_profile.dart';

/// Pantalla administrativa de gestión de usuarios en Inventra.
///
/// Permite listar, filtrar, activar/desactivar y cambiar roles.
class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _searchController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  Future<void> _toggleStatus(UserProfile profile) async {
    try {
      await ref.read(usersProvider.notifier).toggleUserStatus(profile.id, !profile.isActive);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el estado.')),
        );
      }
    }
  }

  Future<void> _updateRole(UserProfile profile, UserRole newRole) async {
    try {
      await ref.read(usersProvider.notifier).updateUserRole(profile.id, newRole);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cambiar el rol.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Header Actions
          Padding(
            padding: EdgeInsets.all(isDesktop ? AppSpacing.xxxl : AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: AppRadius.borderRadiusLg,
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre o correo...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 14,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: usersAsync.when(
              loading: () => const LoadingIndicator(message: 'Cargando listado de perfiles...'),
              error: (e, _) => ErrorView(
                message: 'No pudimos cargar los usuarios.',
                onRetry: () => ref.read(usersProvider.notifier).refresh(),
              ),
              data: (profiles) {
                final filtered = profiles.where((u) {
                  return u.fullName.toLowerCase().contains(_searchQuery) ||
                         u.email.toLowerCase().contains(_searchQuery);
                }).toList();

                if (profiles.isEmpty) {
                  return const EmptyStateView(
                    icon: Icons.people_outline_rounded,
                    title: 'Sin Usuarios',
                    description: 'No hay perfiles sincronizados en el sistema aún.',
                  );
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text('No hay coincidencias en el listado.'));
                }

                return isDesktop
                    ? _buildTableLayout(filtered)
                    : _buildCardLayout(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableLayout(List<UserProfile> profiles) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      itemCount: profiles.length + 1,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _TableHeader();
        }

        final profile = profiles[index - 1];
        return _UserTableRow(
          profile: profile,
          onToggle: () => _toggleStatus(profile),
          onRoleChange: (r) => _updateRole(profile, r),
          dateStr: _dateFormat.format(profile.createdAt.toLocal()),
        );
      },
    );
  }

  Widget _buildCardLayout(List<UserProfile> profiles) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        final profile = profiles[index];
        return _UserMobileCard(
          profile: profile,
          onToggle: () => _toggleStatus(profile),
          onRoleChange: (r) => _updateRole(profile, r),
          dateStr: _dateFormat.format(profile.createdAt.toLocal()),
        );
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _htext('NOMBRE / EMAIL')),
          Expanded(flex: 2, child: _htext('ROL')),
          Expanded(flex: 2, child: _htext('REGISTRO')),
          Expanded(flex: 2, child: _htext('ESTADO')),
          const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _htext(String t) => Text(t, style: AppTextStyles.overline);
}

class _UserTableRow extends StatelessWidget {
  const _UserTableRow({
    required this.profile,
    required this.onToggle,
    required this.onRoleChange,
    required this.dateStr,
  });

  final UserProfile profile;
  final VoidCallback onToggle;
  final Function(UserRole) onRoleChange;
  final String dateStr;

  @override
  Widget build(BuildContext context) {
    final opacity = profile.isActive ? 1.0 : 0.6;

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullName,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    profile.email,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  _RoleBadge(role: profile.role),
                  const SizedBox(width: 4),
                  _RolePicker(current: profile.role, onSelected: onRoleChange),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(dateStr, style: AppTextStyles.bodyMedium),
            ),
            Expanded(
              flex: 2,
              child: _StatusBadge(isActive: profile.isActive),
            ),
            SizedBox(
              width: 80,
              child: Switch(
                value: profile.isActive,
                onChanged: (_) => onToggle(),
                activeThumbColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserMobileCard extends StatelessWidget {
  const _UserMobileCard({
    required this.profile,
    required this.onToggle,
    required this.onRoleChange,
    required this.dateStr,
  });

  final UserProfile profile;
  final VoidCallback onToggle;
  final Function(UserRole) onRoleChange;
  final String dateStr;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 0,
      color: profile.isActive
          ? AppColors.surfaceCard
          : AppColors.surfaceBorder.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusLg,
        side: const BorderSide(color: AppColors.surfaceBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.fullName, style: AppTextStyles.titleMedium),
                      Text(profile.email, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                _StatusBadge(isActive: profile.isActive),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _RoleBadge(role: profile.role),
                    const SizedBox(width: 4),
                    _RolePicker(current: profile.role, onSelected: onRoleChange),
                  ],
                ),
                Switch(value: profile.isActive, onChanged: (_) => onToggle()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});
  final UserRole role;

  @override
  Widget build(BuildContext context) {
    final color = switch (role) {
      UserRole.admin => AppColors.primary,
      UserRole.supervisor => AppColors.secondary,
      UserRole.operador => AppColors.textTertiary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role.value.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RolePicker extends StatelessWidget {
  const _RolePicker({required this.current, required this.onSelected});
  final UserRole current;
  final Function(UserRole) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UserRole>(
      icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.textTertiary),
      onSelected: onSelected,
      itemBuilder: (context) => UserRole.values.map((role) {
        return PopupMenuItem(
          value: role,
          child: Row(
            children: [
              if (role == current) const Icon(Icons.check_rounded, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(role.value),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.secondary : AppColors.textTertiary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Activo' : 'Inactivo',
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
