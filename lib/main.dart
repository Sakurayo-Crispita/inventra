import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/supabase_service.dart';

/// Entry point de Inventra.
///
/// Inicializa Supabase y arranca la app con ProviderScope de Riverpod.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await SupabaseService.initialize();

  runApp(
    const ProviderScope(
      child: InventraApp(),
    ),
  );
}
