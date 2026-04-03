import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Grid de funcionalidades de Inventra.
class LandingFeatures extends StatelessWidget {
  const LandingFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.xxxl : AppSpacing.lg,
        vertical: 80,
      ),
      child: Column(
        children: [
          _SectionTitle(
            title: 'Funcionalidades Potentes',
            subtitle: 'Todo lo que necesitas para administrar tu negocio sin complicaciones.',
            isDesktop: isDesktop,
          ),
          const SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 3 : 1,
            mainAxisSpacing: AppSpacing.xl,
            crossAxisSpacing: AppSpacing.xl,
            childAspectRatio: isDesktop ? 1.4 : 1.6,
            children: const [
              _FeatureCard(
                icon: Icons.inventory_2_outlined,
                title: 'Control de Inventario',
                desc: 'Registra entradas, salidas y movimientos con validación atómica de existencias.',
              ),
              _FeatureCard(
                icon: Icons.category_outlined,
                title: 'Categorización Avanzada',
                desc: 'Organiza tu catálogo en categorías claras para un acceso más ágil y ordenado.',
              ),
              _FeatureCard(
                icon: Icons.people_alt_outlined,
                title: 'Gestión de Equipos',
                desc: 'Administra roles de Admin, Supervisor y Operador con perfiles sincronizados.',
              ),
              _FeatureCard(
                icon: Icons.auto_graph_rounded,
                title: 'Dashboard de Operación',
                desc: 'Visualiza el estado actual de tu negocio mediante métricas y KPIs clave.',
              ),
              _FeatureCard(
                icon: Icons.phonelink_rounded,
                title: 'Multiplataforma',
                desc: 'Accede desde tu navegador web, aplicación de escritorio Windows o Android.',
              ),
              _FeatureCard(
                icon: Icons.shield_outlined,
                title: 'Seguridad Empresarial',
                desc: 'Protección de datos mediante Row Level Security y autenticación segura con Supabase.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle, required this.isDesktop});
  final String title;
  final String subtitle;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.headingMedium),
        const SizedBox(height: 12),
        SizedBox(
          width: isDesktop ? 600 : null,
          child: Text(
            subtitle,
            textAlign: isDesktop ? TextAlign.center : TextAlign.left,
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.icon, required this.title, required this.desc});
  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
