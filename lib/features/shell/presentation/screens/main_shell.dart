import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/app_header.dart';
import '../widgets/mobile_drawer.dart';
import '../widgets/sidebar.dart';

/// Shell principal del panel administrativo.
///
/// Contiene sidebar (desktop) o drawer (mobile), header y área de contenido.
/// Usa ShellRoute de go_router para navegación anidada.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  static const _sectionTitles = [
    'Dashboard',
    'Categorías',
    'Productos',
    'Inventario',
    'Usuarios',
    'Configuración',
  ];

  static const _sectionRoutes = [
    RoutePaths.dashboard,
    RoutePaths.categories,
    RoutePaths.products,
    RoutePaths.inventory,
    RoutePaths.users,
    RoutePaths.settings,
  ];

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  // GlobalKey persistente para el Scaffold (evita inestabilidad en mobile)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _getSelectedIndex(String location) {
    if (location.startsWith(RoutePaths.dashboard)) return 0;
    if (location.startsWith(RoutePaths.categories)) return 1;
    if (location.startsWith(RoutePaths.products)) return 2;
    if (location.startsWith(RoutePaths.inventory)) return 3;
    if (location.startsWith(RoutePaths.users)) return 4;
    if (location.startsWith(RoutePaths.settings)) return 5;
    return 0; // fallback a Dashboard
  }

  void _navigateTo(int index) {
    context.go(MainShell._sectionRoutes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;
    
    // Derivamos el índice de navegación de la ruta actual de GoRouter
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _getSelectedIndex(location);

    if (isDesktop) {
      // ─── Layout desktop: Sidebar + Content ───
      return Scaffold(
        key: _scaffoldKey,
        body: Row(
          children: [
            Sidebar(
              selectedIndex: selectedIndex,
              onItemSelected: _navigateTo,
            ),
            Expanded(
              child: Column(
                children: [
                  AppHeader(
                    title: MainShell._sectionTitles[selectedIndex],
                  ),
                  // Renderizamos el child directamente. 
                  // La transición suave se maneja ahora a nivel de Router.
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ─── Layout mobile: Drawer + AppBar ───
    return Scaffold(
      key: _scaffoldKey,
      drawer: MobileDrawer(
        selectedIndex: selectedIndex,
        onItemSelected: _navigateTo,
      ),
      body: Column(
        children: [
          AppHeader(
            title: MainShell._sectionTitles[selectedIndex],
            showMenuButton: true,
            onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
