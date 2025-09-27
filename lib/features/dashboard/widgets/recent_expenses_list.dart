import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/expenses_provider.dart';
import '../../../core/providers/currency_provider.dart';

/// Widget que muestra una lista de los gastos más recientes
class RecentExpensesList extends ConsumerWidget {
  const RecentExpensesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expensesState = ref.watch(expensesNotifierProvider);
    final currencyNotifier = ref.watch(currencyNotifierProvider.notifier);
    
    // Si no hay gastos, mostrar mensaje vacío
    if (expensesState.expenses.isEmpty) {
      return Card(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long,
                  size: 48,
                  color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Sin gastos recientes',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Los gastos aparecerán aquí',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // Obtener los últimos 4 gastos
    final recentExpenses = expensesState.expenses.take(4).toList();
    
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: recentExpenses.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final expense = recentExpenses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Icono de categoría
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getCategoryColor(expense.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(expense.category),
                    color: _getCategoryColor(expense.category),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Información del gasto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            expense.vehicleId, // TODO: Obtener nombre real del vehículo
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            ' • ${_formatDate(expense.date)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Monto
                Text(
                  currencyNotifier.formatAmount(expense.amount),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Obtiene el color de la categoría basado en el nombre
  Color _getCategoryColor(dynamic category) {
    final categoryName = category?.name?.toLowerCase() ?? '';
    switch (categoryName) {
      case 'fuel':
      case 'combustible':
        return Colors.blue;
      case 'maintenance':
      case 'mantenimiento':
        return Colors.orange;
      case 'insurance':
      case 'seguro':
        return Colors.green;
      case 'parking':
      case 'estacionamiento':
        return Colors.purple;
      case 'tolls':
      case 'peajes':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Obtiene el icono de la categoría basado en el nombre
  IconData _getCategoryIcon(dynamic category) {
    final categoryName = category?.name?.toLowerCase() ?? '';
    switch (categoryName) {
      case 'fuel':
      case 'combustible':
        return Icons.local_gas_station;
      case 'maintenance':
      case 'mantenimiento':
        return Icons.build;
      case 'insurance':
      case 'seguro':
        return Icons.security;
      case 'parking':
      case 'estacionamiento':
        return Icons.local_parking;
      case 'tolls':
      case 'peajes':
        return Icons.toll;
      default:
        return Icons.receipt;
    }
  }

  /// Formatea la fecha para mostrar de forma amigable
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Ayer';
    } else if (difference < 7) {
      return '$difference días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
