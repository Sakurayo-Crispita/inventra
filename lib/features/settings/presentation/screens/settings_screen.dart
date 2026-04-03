import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../application/settings_provider.dart';
import '../../domain/business_settings.dart';

/// Pantalla de configuración del negocio en Inventra.
///
/// Permite editar nombre, moneda, zona horaria e información de contacto.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessNameController;
  late TextEditingController _emailController;
  String? _selectedCurrency;
  String? _selectedTimezone;

  final _currencies = ['PEN', 'USD', 'EUR', 'MXN'];
  final _timezones = [
    'America/Lima',
    'UTC',
    'America/Mexico_City',
    'America/Bogota',
    'America/Santiago',
    'America/Buenos_Aires',
  ];

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initFields(BusinessSettings settings) {
    if (_businessNameController.text.isEmpty) {
      _businessNameController.text = settings.businessName;
    }
    if (_emailController.text.isEmpty) {
      _emailController.text = settings.contactEmail ?? '';
    }
    _selectedCurrency ??= settings.currency;
    _selectedTimezone ??= settings.timezone;
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(settingsProvider.notifier).updateSettings(
            businessName: _businessNameController.text.trim(),
            currency: _selectedCurrency!,
            timezone: _selectedTimezone!,
            contactEmail: _emailController.text.trim(),
          );

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Configuración guardada con éxito'),
          backgroundColor: AppColors.secondary,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la configuración'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    return Container(
      color: AppColors.surface,
      child: settingsAsync.when(
        loading: () => const LoadingIndicator(message: 'Cargando configuración...'),
        error: (e, stack) => ErrorView(
          message: 'No pudimos cargar los ajustes del negocio',
          onRetry: () => ref.read(settingsProvider.notifier).refresh(),
        ),
        data: (settings) {
          _initFields(settings);

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? AppSpacing.xxxl : AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Información del Negocio'),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFormCard([
                    _buildTextField(
                      controller: _businessNameController,
                      label: 'Nombre del Negocio',
                      icon: Icons.business_rounded,
                      validator: (v) => (v == null || v.isEmpty) ? 'El nombre es requerido' : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email de Contacto',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v != null && v.isNotEmpty && !v.contains('@')) ? 'Email inválido' : null,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.xxxl),
                  _buildSectionHeader('Regionalización'),
                  const SizedBox(height: AppSpacing.lg),
                  _buildFormCard([
                    _buildDropdown(
                      label: 'Moneda del Sistema',
                      icon: Icons.payments_outlined,
                      value: _selectedCurrency,
                      items: _currencies,
                      onChanged: (v) => setState(() => _selectedCurrency = v),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _buildDropdown(
                      label: 'Zona Horaria',
                      icon: Icons.schedule_rounded,
                      value: _selectedTimezone,
                      items: _timezones,
                      onChanged: (v) => setState(() => _selectedTimezone = v),
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.xxxl),
                  SizedBox(
                    width: isDesktop ? 200 : double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Guardar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(width: 40, height: 3, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2))),
      ],
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: AppRadius.borderRadiusMd),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: AppRadius.borderRadiusMd),
      ),
    );
  }
}
