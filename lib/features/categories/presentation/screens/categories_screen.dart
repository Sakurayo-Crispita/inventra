import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../application/category_provider.dart';
import '../../domain/category.dart';
import '../widgets/category_form_modal.dart';

/// Pantalla principal del módulo de Categorías.
///
/// Muestra un listado responsivo (lista tipo tarjeta o tabla),
/// e incluye el manejo de los estados Async y la opción de Crear/Editar.
class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key, this.action});

  final String? action;

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
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

  void _showCategoryForm([Category? category]) {
    CategoryFormModal.show(context, category: category);
  }

  Future<void> _toggleStatus(Category category) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(categoriesProvider.notifier)
          .toggleStatus(category.id, !category.isActive);
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Error al cambiar el estado. Inténtalo de nuevo.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    if (_isFirstRender) {
      _isFirstRender = false;
      if (widget.action == 'new') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showCategoryForm();
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
                // Buscador local
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
                        hintText: 'Buscar categoría...',
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

                // Agregar
                if (isDesktop)
                  ElevatedButton.icon(
                    onPressed: _showCategoryForm,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Nueva Categoría'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: 14,
                      ),
                    ),
                  )
                else
                  IconButton.filled(
                    onPressed: _showCategoryForm,
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
            child: categoriesAsync.when(
              loading: () => const LoadingIndicator(message: 'Cargando categorías...'),
              error: (e, stack) => ErrorView(
                message: 'No pudimos cargar las categorías',
                onRetry: () => ref.read(categoriesProvider.notifier).refresh(),
              ),
              data: (categories) {
                // Filtrado local
                final filtered = categories.where((cat) {
                  return cat.name.toLowerCase().contains(_searchQuery) ||
                      (cat.description?.toLowerCase().contains(_searchQuery) ?? false);
                }).toList();

                if (categories.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.category_outlined,
                    title: 'Sin Categorías',
                    description: 'Agrega tu primera categoría para empezar a organizar tu inventario.',
                    actionLabel: 'Crear Categoría',
                    onAction: _showCategoryForm,
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

  /// Estructura de filas densas / tabla para desktop y tablet.
  Widget _buildTableLayout(List<Category> categories) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      itemCount: categories.length + 1, // Header (+1)
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
                Expanded(flex: 3, child: _headerText('Nombre')),
                Expanded(flex: 4, child: _headerText('Descripción')),
                Expanded(flex: 2, child: _headerText('Estado')),
                const SizedBox(width: 120), // Espacio para Acciones
              ],
            ),
          );
        }

        final cat = categories[index - 1];
        return _CategoryTableRow(
          category: cat,
          onEdit: () => _showCategoryForm(cat),
          onToggle: () => _toggleStatus(cat),
        );
      },
    );
  }

  /// Estructura de tarjetas espaciadas para móvil táctil.
  Widget _buildCardLayout(List<Category> categories) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return _CategoryMobileCard(
          category: cat,
          onEdit: () => _showCategoryForm(cat),
          onToggle: () => _toggleStatus(cat),
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

/// Fila para layout de tabla (Escritorio).
class _CategoryTableRow extends StatelessWidget {
  const _CategoryTableRow({
    required this.category,
    required this.onEdit,
    required this.onToggle,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final opacity = category.isActive ? 1.0 : 0.6;

    return Opacity(
      opacity: opacity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                category.name,
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                category.description ?? '-',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 2,
              child: _StatusBadge(isActive: category.isActive),
            ),
            SizedBox(
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Switch(
                    value: category.isActive,
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

/// Tarjeta táctil para layout móvil.
class _CategoryMobileCard extends StatelessWidget {
  const _CategoryMobileCard({
    required this.category,
    required this.onEdit,
    required this.onToggle,
  });

  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 0,
      color: category.isActive
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: AppTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(isActive: category.isActive),
              ],
            ),
            if (category.description != null && category.description!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                category.description!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Switch(
                      value: category.isActive,
                      onChanged: (_) => onToggle(),
                      activeThumbColor: AppColors.primary,
                    ),
                    Text(
                      category.isActive ? 'Activa' : 'Inactiva',
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

/// Etiqueta visual para indicar Activo o Inactivo.
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
