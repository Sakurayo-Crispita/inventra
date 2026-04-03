import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../data/settings_repository.dart';
import '../domain/business_settings.dart';

/// Provider expuesto del Repositorio de Configuración.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// Provider controlador central de los ajustes globales.
///
/// Refleja la configuración maestra de Inventra de forma reactiva.
final settingsProvider = AsyncNotifierProvider<SettingsNotifier, BusinessSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<BusinessSettings> {
  late SettingsRepository _repository;

  @override
  FutureOr<BusinessSettings> build() async {
    _repository = ref.read(settingsRepositoryProvider);
    return _repository.fetchSettings();
  }

  /// Actualiza los ajustes globales en la base de datos.
  Future<void> updateSettings({
    required String businessName,
    required String currency,
    required String timezone,
    String? contactEmail,
  }) async {
    if (!state.hasValue) return;

    try {
      final updatedSettings = state.value!.copyWith(
        businessName: businessName,
        currency: currency,
        timezone: timezone,
        contactEmail: contactEmail,
      );

      final result = await _repository.updateSettings(updatedSettings);
      state = AsyncData(result);
    } on AppException {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchSettings());
  }
}
