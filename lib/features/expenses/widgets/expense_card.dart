import 'package:flutter/material.dart';
import '../../../core/models/expense_model.dart';

/// Widget de tarjeta para mostrar un gasto individual
class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con categoría y monto
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(expense.category).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(expense.category),
                      color: _getCategoryColor(expense.category),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getCategoryName(expense.category),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${expense.currency} ${expense.amount.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      Text(
                        _formatDate(expense.date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Información adicional si existe
              if (expense.location != null || expense.odometer != null || expense.quantity != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (expense.location != null)
                        _buildInfoChip(
                          Icons.location_on_outlined,
                          expense.location!,
                          theme,
                        ),
                      if (expense.odometer != null)
                        _buildInfoChip(
                          Icons.speed,
                          '${expense.odometer!.toStringAsFixed(0)} km',
                          theme,
                        ),
                      if (expense.quantity != null)
                        _buildInfoChip(
                          Icons.local_gas_station,
                          '${expense.quantity!.toStringAsFixed(1)} L',
                          theme,
                        ),
                    ],
                  ),
                ),
              
              // Notas si existen
              if (expense.notes != null && expense.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    expense.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              
              // Botones de acción
              if (onEdit != null || onDelete != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onEdit != null)
                        TextButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Editar'),
                        ),
                      if (onDelete != null)
                        TextButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete, size: 16),
                          label: const Text('Eliminar'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'Hoy';
    } else if (difference == 1) {
      return 'Ayer';
    } else if (difference < 7) {
      return 'Hace $difference días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getCategoryName(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return 'Combustible';
      case ExpenseCategory.maintenance:
        return 'Mantenimiento';
      case ExpenseCategory.repairs:
        return 'Reparaciones';
      case ExpenseCategory.insurance:
        return 'Seguro';
      case ExpenseCategory.registration:
        return 'Registro';
      case ExpenseCategory.parking:
        return 'Estacionamiento';
      case ExpenseCategory.tolls:
        return 'Peajes';
      case ExpenseCategory.accessories:
        return 'Accesorios';
      case ExpenseCategory.cleaning:
        return 'Limpieza';
      case ExpenseCategory.other:
        return 'Otros';
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Icons.local_gas_station;
      case ExpenseCategory.maintenance:
        return Icons.build;
      case ExpenseCategory.repairs:
        return Icons.handyman;
      case ExpenseCategory.insurance:
        return Icons.security;
      case ExpenseCategory.registration:
        return Icons.description;
      case ExpenseCategory.parking:
        return Icons.local_parking;
      case ExpenseCategory.tolls:
        return Icons.toll;
      case ExpenseCategory.accessories:
        return Icons.shopping_bag;
      case ExpenseCategory.cleaning:
        return Icons.local_car_wash;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Colors.red;
      case ExpenseCategory.maintenance:
        return Colors.blue;
      case ExpenseCategory.repairs:
        return Colors.orange;
      case ExpenseCategory.insurance:
        return Colors.green;
      case ExpenseCategory.registration:
        return Colors.purple;
      case ExpenseCategory.parking:
        return Colors.teal;
      case ExpenseCategory.tolls:
        return Colors.brown;
      case ExpenseCategory.accessories:
        return Colors.pink;
      case ExpenseCategory.cleaning:
        return Colors.cyan;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }
}
