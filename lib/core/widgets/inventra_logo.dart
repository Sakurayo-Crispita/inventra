import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Logo placeholder minimalista de Inventra.
///
/// Icono geométrico con forma de caja/inventario estilizada.
/// Diseñado para ser reemplazado fácilmente por un logo final.
class InventraLogo extends StatelessWidget {
  const InventraLogo({
    super.key,
    this.size = 40,
    this.color,
    this.showText = false,
  });

  final double size;
  final Color? color;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? AppColors.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                logoColor,
                logoColor.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Caja exterior
              Icon(
                Icons.inventory_2_outlined,
                size: size * 0.55,
                color: Colors.white,
              ),
              // Detalle geométrico
              Positioned(
                right: size * 0.12,
                top: size * 0.12,
                child: Container(
                  width: size * 0.18,
                  height: size * 0.18,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(size * 0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          SizedBox(width: size * 0.3),
          Text(
            'Inventra',
            style: TextStyle(
              fontSize: size * 0.45,
              fontWeight: FontWeight.w800,
              color: logoColor,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}
