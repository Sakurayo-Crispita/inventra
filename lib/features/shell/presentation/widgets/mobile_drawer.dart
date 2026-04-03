import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/inventra_logo.dart';

/// Drawer de navegación para móvil.
///
/// Replica la estructura del sidebar pero en formato drawer.
class MobileDrawer extends StatelessWidget {
  const MobileDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final int selectedIndex;
  final void Function(int index) onItemSelected;

  static const _navItems = [
    (Icons.dashboard_rounded, 'Dashboard'),
    (Icons.category_rounded, 'Categorías'),
    (Icons.inventory_2_rounded, 'Productos'),
    (Icons.swap_vert_rounded, 'Inventario'),
    (Icons.people_rounded, 'Usuarios'),
    (Icons.settings_rounded, 'Configuración'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surfaceCard,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Logo ───
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: InventraLogo(size: 36, showText: true),
            ),
            const Divider(),

            // ─── Sección ───
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xl,
                top: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                'MENÚ PRINCIPAL',
                style: AppTextStyles.overline.copyWith(letterSpacing: 1.5),
              ),
            ),

            // ─── Items ───
            Expanded(
              child: ListView.builder(
                itemCount: _navItems.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                itemBuilder: (context, index) {
                  final (icon, label) = _navItems[index];
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: ListTile(
                      leading: Icon(
                        icon,
                        color: isSelected
                            ? AppColors.textOnPrimary
                            : AppColors.sidebarText,
                        size: 22,
                      ),
                      title: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.textOnPrimary
                              : AppColors.sidebarText,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppColors.sidebarActive,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected(index);
                      },
                    ),
                  );
                },
              ),
            ),

            // ─── Footer ───
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Inventra v1.0.0',
                style: AppTextStyles.caption,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
