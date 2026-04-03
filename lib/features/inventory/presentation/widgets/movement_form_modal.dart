import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../products/application/product_provider.dart';
import '../../application/inventory_provider.dart';

/// Modal flotante para el Registro de Movimientos de Entrada o Salida.
class MovementFormModal extends ConsumerStatefulWidget {
  const MovementFormModal({super.key, this.initialType});

  final String? initialType;

  static Future<void> show(BuildContext context, {String? initialType}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => MovementFormModal(initialType: initialType),
    );
  }

  @override
  ConsumerState<MovementFormModal> createState() => _MovementFormModalState();
}

class _MovementFormModalState extends ConsumerState<MovementFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();

  String? _selectedProductId;
  late String _movementType;
  int _currentStockOfSelected = 0;

  @override
  void initState() {
    super.initState();
    _movementType = widget.initialType ?? 'entrada';
  }

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _onProductChanged(String? productId) {
    setState(() {
      _selectedProductId = productId;
      
      // Actualizamos la visualización del stock actual del producto elegido
      if (productId != null) {
        final productsAsync = ref.read(productsProvider);
        if (productsAsync.hasValue) {
          final prod = productsAsync.value!.firstWhere((p) => p.id == productId);
          _currentStockOfSelected = prod.currentStock;
        }
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProductId == null) {
      setState(() => _errorMessage = 'Selecciona un producto para la transacción.');
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    if (quantity <= 0) {
      setState(() => _errorMessage = 'La cantidad debe ser mayor a cero.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final desc = _reasonController.text.trim();
      final reason = desc.isEmpty ? null : desc;

      await ref.read(inventoryProvider.notifier).addMovement(
            productId: _selectedProductId!,
            movementType: _movementType,
            quantity: quantity,
            reason: reason,
          );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on AppException catch (e) {
      setState(() {
        _errorMessage = ErrorHandler.userMessage(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error inesperado al regitrar la validación de inventario.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < AppSpacing.breakpointTablet;

    final productsAsync = ref.watch(productsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
      backgroundColor: AppColors.surfaceCard,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: isMobile ? double.infinity : 480,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Registrar Movimiento',
                    style: AppTextStyles.titleLarge,
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

               // Errores
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderRadiusSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.danger),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Selector de tipo (Segmented Control manual)
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _isLoading ? null : () => setState(() => _movementType = 'entrada'),
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _movementType == 'entrada' ? AppColors.secondary.withValues(alpha: 0.15) : AppColors.surface,
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                                border: Border.all(
                                  color: _movementType == 'entrada' ? AppColors.secondary : AppColors.surfaceBorder,
                                ),
                              ),
                              child: Text('ENTRADA (+)', 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _movementType == 'entrada' ? AppColors.secondaryDark : AppColors.textSecondary
                                )
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: _isLoading ? null : () => setState(() => _movementType = 'salida'),
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _movementType == 'salida' ? AppColors.danger.withValues(alpha: 0.15) : AppColors.surface,
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                                border: Border.all(
                                  color: _movementType == 'salida' ? AppColors.danger : AppColors.surfaceBorder,
                                ),
                              ),
                              child: Text('SALIDA (-)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _movementType == 'salida' ? AppColors.dangerDark : AppColors.textSecondary
                                )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Selector de Producto (Dropdown)
                    productsAsync.when(
                      loading: () => const LinearProgressIndicator(),
                      error: (err, _) => Text('Error cargando productos: $err'),
                      data: (prods) {
                        final activeProducts = prods.where((p) => p.isActive).toList();
                        
                        if (activeProducts.isEmpty) {
                          return _buildWarningBanner('No hay productos habilitados. Crea uno primero.');
                        }

                        return DropdownButtonFormField<String>(
                          initialValue: _selectedProductId,
                          decoration: const InputDecoration(
                            labelText: 'Producto *',
                            prefixIcon: Icon(Icons.inventory_2_outlined),
                          ),
                          items: activeProducts.map((p) {
                            return DropdownMenuItem(
                              value: p.id,
                              child: Text('${p.sku} - ${p.name}'),
                            );
                          }).toList(),
                          onChanged: _isLoading ? null : _onProductChanged,
                          validator: (val) => val == null ? 'Selecciona un producto' : null,
                        );
                      },
                    ),
                    
                    // Indicador de Stock Actual Contextual
                    if (_selectedProductId != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Stock actual: $_currentStockOfSelected unidades',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _currentStockOfSelected <= 0 && _movementType == 'salida'
                                ? AppColors.danger
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.lg),

                    // Cantidad
                    TextFormField(
                      controller: _quantityController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Cantidad *',
                        hintText: 'Ej. 10',
                        prefixIcon: Icon(
                          _movementType == 'entrada' ? Icons.add_circle_outline : Icons.remove_circle_outline,
                          color: _movementType == 'entrada' ? AppColors.secondary : AppColors.danger,
                        ),
                        suffixText: 'uds.',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa la cantidad';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Razón Opcional
                    TextFormField(
                      controller: _reasonController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Motivo (Opcional)',
                        hintText: 'Ej. Compra a proveedor local',
                        prefixIcon: Icon(Icons.speaker_notes_outlined),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 2,
                      minLines: 1,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppSpacing.xxxl),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _movementType == 'entrada' ? AppColors.secondary : AppColors.danger,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : const Text('Confirmar Traspaso'),
                  ),
                ],
              ),
            ],
          )
        )
      )
    );
  }

  Widget _buildWarningBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentDark.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: AppColors.accentDark.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.accentDark),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
