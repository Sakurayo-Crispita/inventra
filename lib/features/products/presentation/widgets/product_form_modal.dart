import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/application/category_provider.dart';
import '../../application/product_provider.dart';
import '../../domain/product.dart';

/// Modal para crear o editar un producto.
class ProductFormModal extends ConsumerStatefulWidget {
  const ProductFormModal({super.key, this.productToEdit});

  final Product? productToEdit;

  static Future<void> show(BuildContext context, {Product? product}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProductFormModal(productToEdit: product),
    );
  }

  @override
  ConsumerState<ProductFormModal> createState() => _ProductFormModalState();
}

class _ProductFormModalState extends ConsumerState<ProductFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descController = TextEditingController();
  final _minStockController = TextEditingController();
  final _imageController = TextEditingController();

  String? _selectedCategoryId;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nameController.text = p.name;
      _skuController.text = p.sku;
      _descController.text = p.description ?? '';
      _minStockController.text = p.minStock.toString();
      _imageController.text = p.imageUrl ?? '';
      _selectedCategoryId = p.categoryId;
    } else {
      _minStockController.text = '0'; // default
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descController.dispose();
    _minStockController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      setState(() => _errorMessage = 'Selecciona una categoría obligatoria.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final name = _nameController.text.trim();
      final sku = _skuController.text.trim();
      final desc = _descController.text.trim();
      final description = desc.isEmpty ? null : desc;
      final minStock = int.tryParse(_minStockController.text.trim()) ?? 0;
      final img = _imageController.text.trim();
      final imageUrl = img.isEmpty ? null : img;

      if (widget.productToEdit == null) {
        await ref.read(productsProvider.notifier).addProduct(
              name: name,
              sku: sku,
              categoryId: _selectedCategoryId!,
              description: description,
              minStock: minStock,
              imageUrl: imageUrl,
            );
      } else {
        await ref.read(productsProvider.notifier).updateProduct(
              id: widget.productToEdit!.id,
              name: name,
              sku: sku,
              categoryId: _selectedCategoryId!,
              description: description,
              minStock: minStock,
              imageUrl: imageUrl,
            );
      }

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
        _errorMessage = 'Ocurrió un error inesperado al guardar el producto.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < AppSpacing.breakpointTablet;

    // Obtener categorías activas disponibles para el Dropdown
    final categoriesAsync = ref.watch(categoriesProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusLg),
      backgroundColor: AppColors.surfaceCard,
      surfaceTintColor: Colors.transparent,
      child: Container(
        width: isMobile ? double.infinity : 550,
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
                    isEditing ? 'Editar Producto' : 'Nuevo Producto',
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

              // Errores locales
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

              // Área Scirollable del Formulario si es necesario en móviles
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // SKU
                    TextFormField(
                      controller: _skuController,
                      enabled: !_isLoading && !isEditing, // A veces el SKU no se permite editar
                      decoration: const InputDecoration(
                        labelText: 'SKU / Código *',
                        hintText: 'Ej. LAP-HP-450',
                        prefixIcon: Icon(Icons.qr_code_2_rounded),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El SKU es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Nombre
                    TextFormField(
                      controller: _nameController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Producto *',
                        hintText: 'Ej. Laptop HP ProBook',
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Selector de Categoría (Dropdown)
                    categoriesAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: LinearProgressIndicator(),
                      ),
                      error: (err, _) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Text(
                          'Error cargando categorías: $err',
                          style: TextStyle(color: AppColors.danger),
                        ),
                      ),
                      data: (cats) {
                        final activeCategories = cats.where((c) => c.isActive).toList();

                        // Si estamos editando y la categoría original ya fue desactivada, podemos
                        // temporalmente sumarle a la lista para no romper el dropdown.
                        if (widget.productToEdit != null &&
                            !activeCategories.any((c) => c.id == widget.productToEdit!.categoryId)) {
                          final inactiveCat = cats.firstWhere(
                            (c) => c.id == widget.productToEdit!.categoryId,
                            orElse: () => cats.first, // fallback seguro
                          );
                          activeCategories.add(inactiveCat);
                        }

                        if (activeCategories.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.accentDark.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderRadiusMd,
                              border: Border.all(color: AppColors.accentDark.withValues(alpha: 0.5)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.warning_amber_rounded, color: AppColors.accentDark),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    'No hay categorías activas. Crea una en la sección de Categorías primero.',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return DropdownButtonFormField<String>(
                          initialValue: _selectedCategoryId,
                          decoration: const InputDecoration(
                            labelText: 'Categoría *',
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          items: activeCategories.map((c) {
                            return DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            );
                          }).toList(),
                          onChanged: _isLoading
                              ? null
                              : (val) => setState(() => _selectedCategoryId = val),
                          validator: (val) {
                            if (val == null) return 'Selecciona una categoría obligatoria';
                            return null;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Stock Mínimo
                    TextFormField(
                      controller: _minStockController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Stock Mínimo',
                        hintText: 'Ej. 5',
                        prefixIcon: Icon(Icons.warning_amber_rounded),
                        suffixText: 'uds.',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa un número (usa 0 si no aplica)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // URL Imagen 
                    TextFormField(
                      controller: _imageController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'URL de Imagen (Opcional - Fase 2)',
                        hintText: 'https://...',
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Descripción
                    TextFormField(
                      controller: _descController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Descripción (Opcional)',
                        hintText: 'Ej. Detalles técnicos o comerciales',
                        prefixIcon: Icon(Icons.description_outlined),
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
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textOnPrimary,
                            ),
                          )
                        : Text(isEditing ? 'Guardar Cambios' : 'Crear Producto'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
