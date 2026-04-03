import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../application/inventory_provider.dart';
import '../../domain/inventory_movement.dart';
import '../widgets/movement_form_modal.dart';

/// Pantalla responsable del historial transaccional de todos los movimientos.
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({
    super.key,
    this.action,
  });

  final String? action;

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  bool _isFirstRender = true;
  final _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  void _showMovementForm([String? type]) {
    MovementFormModal.show(context, initialType: type);
  }

  @override
  Widget build(BuildContext context) {
    final movementsAsync = ref.watch(inventoryProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= AppSpacing.breakpointTablet;

    if (_isFirstRender) {
      _isFirstRender = false;
      if (widget.action == 'entry' || widget.action == 'exit') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showMovementForm(widget.action == 'entry' ? 'entrada' : 'salida');
        });
      }
    }

    return Container(
      color: AppColors.surface,
      child: Column(
        children: [
          // Header Flotante
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
                        hintText: 'Filtrar por nombre de producto, código o razón...',
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
                ElevatedButton.icon(
                  onPressed: () => _showMovementForm(),
                  icon: const Icon(Icons.swap_vert_rounded),
                  label: Text(isDesktop ? 'Registrar Movimiento' : 'Movimiento'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                      vertical: isDesktop ? 14 : 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Historial de lista
          Expanded(
            child: movementsAsync.when(
              loading: () => const LoadingIndicator(message: 'Cargando movimientos reales...'),
              error: (e, _) => ErrorView(
                message: 'No pudimos cargar el inventario. Asegúrate de tener permisos.',
                onRetry: () => ref.read(inventoryProvider.notifier).refresh(),
              ),
              data: (movements) {
                final filtered = movements.where((m) {
                  final n = m.productName?.toLowerCase() ?? '';
                  final s = m.productSku?.toLowerCase() ?? '';
                  final r = m.reason?.toLowerCase() ?? '';
                  return n.contains(_searchQuery) ||
                         s.contains(_searchQuery) ||
                         r.contains(_searchQuery);
                }).toList();

                if (movements.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.history_rounded,
                    title: 'Inventario Estático',
                    description: 'Tus productos no han registrado ningún flujo de inventario.\nRegistra tu primer saldo cargando stock.',
                    actionLabel: 'Registrar Entrada',
                    onAction: () => _showMovementForm('entrada'),
                  );
                }

                if (filtered.isEmpty) {
                  return const Center(child: Text('No hay coincidencias en el historial.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final mv = filtered[index];
                    return _MovementListTile(
                      movement: mv,
                      dateStr: _dateFormat.format(mv.createdAt.toLocal()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MovementListTile extends StatelessWidget {
  const _MovementListTile({
    required this.movement,
    required this.dateStr,
  });

  final InventoryMovement movement;
  final String dateStr;

  @override
  Widget build(BuildContext context) {
    final isEntry = movement.isEntry;
    final color = isEntry ? AppColors.secondary : AppColors.danger;
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono principal (Refleja la suma/resta)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Icon(
              isEntry ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),

          // Detalles Centrales
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movement.productName ?? 'Producto Desconocido',
                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                ),
                if (movement.reason != null)
                  Text(
                    movement.reason!,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    movement.productSku ?? '-',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Lado de valores transaccionales y cronología
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isEntry ? '+' : '-'} ${movement.quantity}',
                style: AppTextStyles.titleMedium.copyWith(color: color),
              ),
              const SizedBox(height: 4),
              Text(
                dateStr,
                style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
