import '../../../core/errors/error_handler.dart';
import '../../../core/services/supabase_service.dart';
import '../domain/business_settings.dart';

/// Repositorio de configuración global.
///
/// Gestiona la lectura y actualización de la configuración maestra en `public.settings`.
class SettingsRepository {
  /// Obtiene los ajustes globales del negocio.
  Future<BusinessSettings> fetchSettings() async {
    try {
      final response = await SupabaseService.client
          .from('settings')
          .select('*')
          .eq('id', 1)
          .single();

      return BusinessSettings.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }

  /// Actualiza la configuración global.
  Future<BusinessSettings> updateSettings(BusinessSettings settings) async {
    try {
      final response = await SupabaseService.client
          .from('settings')
          .update({
            'business_name': settings.businessName,
            'currency': settings.currency,
            'timezone': settings.timezone,
            'contact_email': settings.contactEmail,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', 1)
          .select('*')
          .single();

      return BusinessSettings.fromJson(response);
    } catch (e, stack) {
      throw ErrorHandler.handle(e, stack);
    }
  }
}
