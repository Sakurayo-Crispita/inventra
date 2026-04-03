import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/inventra_logo.dart';
import '../../application/shell_provider.dart';
import 'sidebar_item.dart';

/// Sidebar principal de Inventra.
///
/// Navegación lateral con logo, items y estado colapsable.
/// Gradiente sutil de fondo inspirado en el diseño de referencia.
class Sidebar extends ConsumerWidget {
  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final void Function(int index) onItemSelected;

  static const _navItems = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'Dashboard'),
    _NavItem(Icons.category_outlined, Icons.category_rounded, 'Categorías'),
    _NavItem(Icons.inventory_2_outlined, Icons.inventory_2_rounded, 'Productos'),
    _NavItem(Icons.swap_vert_outlined, Icons.swap_vert_rounded, 'Inventario'),
    _NavItem(Icons.people_outline, Icons.people_rounded, 'Usuarios'),
    _NavItem(Icons.settings_outlined, Icons.settings_rounded, 'Configuración'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final width = isCollapsed
        ? AppSpacing.sidebarCollapsed
        : AppSpacing.sidebarExpanded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.gradientSidebar,
          border: Border(
            right: BorderSide(
              color: AppColors.surfaceBorder,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // ─── Logo ───
            SizedBox(
              height: 72,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isCollapsed ? AppSpacing.md : AppSpacing.xl,
                ),
                child: ClipRect(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InventraLogo(
                        size: isCollapsed ? 32 : 36,
                        showText: !isCollapsed,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Divider(indent: 16, endIndent: 16),
            const SizedBox(height: AppSpacing.sm),

            // ─── Sección principal ───
            if (!isCollapsed)
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.xxl,
                  bottom: AppSpacing.sm,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MENÚ PRINCIPAL',
                    style: AppTextStyles.overline.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

            // ─── Navigation Items ───
            Expanded(
              child: ListView.builder(
                itemCount: _navItems.length,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                itemBuilder: (context, index) {
                  final item = _navItems[index];
                  return SidebarItem(
                    icon: selectedIndex == index ? item.activeIcon : item.icon,
                    label: item.label,
                    isSelected: selectedIndex == index,
                    isCollapsed: isCollapsed,
                    onTap: () => onItemSelected(index),
                  );
                },
              ),
            ),

            // ─── Botón colapsar ───
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SidebarItem(
                icon: isCollapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                label: isCollapsed ? 'Expandir' : 'Contraer',
                isSelected: false,
                isCollapsed: isCollapsed,
                onTap: () {
                  ref.read(sidebarCollapsedProvider.notifier).state =
                      !isCollapsed;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.activeIcon, this.label);
  final IconData icon;
  final IconData activeIcon;
  final String label;
}
