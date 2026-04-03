import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/application/auth_provider.dart';

/// Barra de navegación inteligente de la Landing Web.
///
/// Cambia su comportamiento de acceso según la sesión del usuario.
class LandingNavbar extends ConsumerWidget {
  const LandingNavbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.xxxl : AppSpacing.lg,
      ),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Inventra',
                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // Acciones
          Row(
            children: [
              if (isDesktop) ...[
                _navLink('Funciones'),
                _navLink('Beneficios'),
                const SizedBox(width: AppSpacing.lg),
              ],
              _AccessButton(isAuthenticated: authState.isAuthenticated),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navLink(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: TextButton(
        onPressed: () {},
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({required this.isAuthenticated});
  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final label = isAuthenticated ? 'Acceder al Panel' : 'Iniciar Sesión';

    return ElevatedButton(
      onPressed: () => launchUrl(Uri.parse(AppConstants.webPanelUrl)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
