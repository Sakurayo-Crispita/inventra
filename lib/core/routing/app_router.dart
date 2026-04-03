import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/users/presentation/screens/users_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import 'route_names.dart';

/// Configuración de rutas de Inventra usando go_router.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RoutePaths.landing,
    debugLogDiagnostics: true,

    // ─── Guard de autenticación ───
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == RoutePaths.login;
      final isLandingRoute = state.matchedLocation == RoutePaths.landing;

      if (!isAuthenticated && !isLoginRoute && !isLandingRoute) {
        return RoutePaths.login;
      }
      if (isAuthenticated && isLoginRoute) {
        return RoutePaths.dashboard;
      }
      return null;
    },

    routes: [
      // ─── Landing Pública (Raíz) ───
      GoRoute(
        path: RoutePaths.landing,
        name: RouteNames.landing,
        builder: (context, state) => const LandingScreen(),
      ),

      // ─── Login (fuera del shell) ───
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ─── Shell principal con navegación anidada ───
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RoutePaths.dashboard,
            name: RouteNames.dashboard,
            pageBuilder: (context, state) => _fadeTransition(const DashboardScreen()),
          ),
          GoRoute(
            path: RoutePaths.categories,
            name: RouteNames.categories,
            pageBuilder: (context, state) {
              final action = state.uri.queryParameters['action'];
              return _fadeTransition(CategoriesScreen(action: action));
            },
          ),
          GoRoute(
            path: RoutePaths.products,
            name: RouteNames.products,
            pageBuilder: (context, state) {
              final action = state.uri.queryParameters['action'];
              return _fadeTransition(ProductsScreen(action: action));
            },
          ),
          GoRoute(
            path: RoutePaths.inventory,
            name: RouteNames.inventory,
            pageBuilder: (context, state) {
              final action = state.uri.queryParameters['action'];
              return _fadeTransition(InventoryScreen(action: action));
            },
          ),
          GoRoute(
            path: RoutePaths.users,
            name: RouteNames.users,
            pageBuilder: (context, state) => _fadeTransition(const UsersScreen()),
          ),
          GoRoute(
            path: RoutePaths.settings,
            name: RouteNames.settings,
            pageBuilder: (context, state) => _fadeTransition(const SettingsScreen()),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Página no encontrada: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.dashboard),
              child: const Text('Ir al Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Función auxiliar para transiciones de tipo Fade (desvanecimiento) suaves y estables.
CustomTransitionPage _fadeTransition(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}
