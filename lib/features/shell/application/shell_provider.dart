import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider del estado de la sidebar.
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);

/// Índice de navegación actual del shell.
final currentNavIndexProvider = StateProvider<int>((ref) => 0);
