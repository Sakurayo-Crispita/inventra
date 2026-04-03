import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../application/product_provider.dart';
import '../../domain/product.dart';
import '../widgets/product_form_modal.dart';

/// Pantalla principal del módulo de Productos.
///
/// Listado responsivo para gestión de inventario base (Tabla/Tarjetas).
class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key, this.action});

  final String? action;

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  bool _isFirstRender = true;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  void _showProductForm([Product? product]) {
    ProductFormModal.show(context, product: product);
  }

  Future<void> _toggleStatus(Product product) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(productsProvider.notifier)
          .toggleStatus(product.id, !product.isActive);
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error al cambiar el estado. Inténtalo de nuevo.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    if (_isFirstRender) {
      _isFirstRender = false;
      if (widget.action == 'new') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showProductForm();
        });
      }
    }

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // ─── Header de acciones ───
          Padding(
            padding: EdgeInsets.all(isDesktop ? AppSpacing.xxxl : AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCard,
                      borderRadius: AppRadius.borderRadiusLg,
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Buscar producto por nombre o SKU...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 14,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                if (isDesktop)
                  ElevatedButton.icon(
                    onPressed: _showProductForm,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Nuevo Producto'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: 14,
                      ),
                    ),
                  )
                else
                  IconButton.filled(
                    onPressed: _showProductForm,
                    icon: const Icon(Icons.add_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.borderRadiusLg,
                      ),
                      minimumSize: const Size(48, 48),
                    ),
                  ),
              ],
            ),
          ),

          // ─── Contenido ───
          Expanded(
            child: productsAsync.when(
              loading: () => const LoadingIndicator(message: 'Cargando productos...'),
              error: (e, stack) => ErrorView(
                message: 'No pudimos cargar los productos',
                onRetry: () => ref.read(productsProvider.notifier).refresh(),
              ),
              data: (products) {
                final filtered = products.where((prod) {
                  return prod.name.toLowerCase().contains(_searchQuery) ||
                         prod.sku.toLowerCase().contains(_searchQuery);
                }).toList();

                if (products.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.inventory_2_outlined,
                    title: 'Sin Productos',
                    description: 'Aún no hay productos registrados en tu inventario.',
                    actionLabel: 'Crear Producto',
                    onAction: _showProductForm,
                  );
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text('No hay coincidencias en tu búsqueda.'));
                }

                return isDesktop
                    ? _buildTableLayout(filtered)
                    : _buildCardLayout(filtered);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableLayout(List<Product> products) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      itemCount: products.length + 1,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == 0) {
          // Header Row
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: _headerText('SKU / Nombre')),
                Expanded(flex: 2, child: _headerText('Categoría')),
                Expanded(flex: 1, child: _headerText('Stock')),
                Expanded(flex: 1, child: _headerText('Mínimo')),
                Expanded(flex: 1, child: _headerText('Estado')),
                const SizedBox(width: 120), // Acciones
              ],
            ),
          );
        }

        final prod = products[index - 1];
        return _ProductTableRow(
          product: prod,
          onEdit: () => _showProductForm(prod),
          onToggle: () => _toggleStatus(prod),
        );
      },
    );
  }

  Widget _buildCardLayout(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        return _ProductMobileCard(
          product: prod,
          onEdit: () => _showProductForm(prod),
          onToggle: () => _toggleStatus(prod),
        );
      },
    );
  }

  Widget _headerText(String text) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.overline,
    );
  }
}

class _ProductTableRow extends StatelessWidget {
  const _ProductTableRow({
    required this.product,
    required this.onEdit,
    required this.onToggle,
  });

  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final opacity = product.isActive ? 1.0 : 0.6;

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.sku,
                    style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                product.categoryName ?? 'Sin categoría',
                style: AppTextStyles.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${product.currentStock}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: product.currentStock <= product.minStock ? AppColors.danger : AppColors.secondaryDark,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                '${product.minStock}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _StatusBadge(isActive: product.isActive),
              ),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Switch(
                    value: product.isActive,
                    onChanged: (_) => onToggle(),
                    activeThumbColor: AppColors.primary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: onEdit,
                    color: AppColors.textSecondary,
                    tooltip: 'Editar',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductMobileCard extends StatelessWidget {
  const _ProductMobileCard({
    required this.product,
    required this.onEdit,
    required this.onToggle,
  });

  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 0,
      color: product.isActive
          ? AppColors.surfaceCard
          : AppColors.surfaceBorder.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusLg,
        side: const BorderSide(
          color: AppColors.surfaceBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${product.sku}',
                        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(isActive: product.isActive),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                const Icon(Icons.category_outlined, size: 16, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    product.categoryName ?? '-',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.textTertiary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Min: ${product.minStock}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (product.currentStock <= product.minStock ? AppColors.danger : AppColors.secondary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Stock: ${product.currentStock}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: product.currentStock <= product.minStock ? AppColors.dangerDark : AppColors.secondaryDark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      value: product.isActive,
                      onChanged: (_) => onToggle(),
                      activeThumbColor: AppColors.primary,
                    ),
                    Text(
                      product.isActive ? 'Activo' : 'Inactivo',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.secondary : AppColors.textTertiary;
    final text = isActive ? 'Activo' : 'Inactivo';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderRadiusFull,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
