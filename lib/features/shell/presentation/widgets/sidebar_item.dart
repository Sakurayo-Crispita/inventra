import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Item individual del sidebar de navegación.
///
/// Muestra icono con label, con estados hover/active/collapsed.
class SidebarItem extends StatefulWidget {
  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isCollapsed = false,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCollapsed;

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected;
    final bgColor = isActive
        ? AppColors.primarySurface.withValues(alpha: 0.1)
        : _isHovered
            ? AppColors.surfaceHover
            : Colors.transparent;
    final iconColor = isActive
        ? AppColors.primary
        : _isHovered
            ? AppColors.primary
            : AppColors.sidebarText;
    final textColor = isActive
        ? AppColors.primary
        : _isHovered
            ? AppColors.textPrimary
            : AppColors.sidebarText;

    final content = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          height: AppSpacing.sidebarItemHeight,
          margin: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? AppSpacing.sm : AppSpacing.md,
            vertical: 2,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCollapsed ? 0 : AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppRadius.borderRadiusSm,
            // Sombra eliminada a petición del usuario para un look más limpio.
          ),
          child: Row(
            mainAxisAlignment: widget.isCollapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: iconColor),
              if (!widget.isCollapsed) ...[
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (widget.isCollapsed) {
      return Tooltip(
        message: widget.label,
        preferBelow: false,
        child: content,
      );
    }

    return content;
  }

  IconData get icon => widget.icon;
}
