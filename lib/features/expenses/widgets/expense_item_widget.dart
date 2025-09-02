import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/providers/expenses_provider.dart';
import '../../../core/providers/vehicles_provider.dart';

/// Widget para mostrar un elemento de gasto con opciones de edición y eliminación
class ExpenseItemWidget extends ConsumerWidget {
  final ExpenseModel expense;
  final VoidCallback? onEdit;

  const ExpenseItemWidget({
    super.key,
    required this.expense,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vehiclesState = ref.watch(vehiclesNotifierProvider);
    
    // Buscar el vehículo asociado
    final vehicle = vehiclesState.vehicles.firstWhere(
      (v) => v.id == expense.vehicleId,
      orElse: () => vehiclesState.vehicles.first,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(expense.category),
          child: Icon(
            _getCategoryIcon(expense.category),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          expense.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${vehicle.brand} ${vehicle.model}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${expense.date.day}/${expense.date.month}/${expense.date.year}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${expense.amount.toStringAsFixed(2)} ${expense.currency}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            if (expense.quantity != null)
              Text(
                '${expense.quantity!.toStringAsFixed(1)} L',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        onTap: () => _showExpenseDetails(context, ref),
        onLongPress: () => _showOptionsBottomSheet(context, ref),
      ),
    );
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Colors.blue;
      case ExpenseCategory.maintenance:
        return Colors.orange;
      case ExpenseCategory.repairs:
        return Colors.red;
      case ExpenseCategory.insurance:
        return Colors.green;
      case ExpenseCategory.registration:
        return Colors.purple;
      case ExpenseCategory.parking:
        return Colors.teal;
      case ExpenseCategory.tolls:
        return Colors.indigo;
      case ExpenseCategory.accessories:
        return Colors.pink;
      case ExpenseCategory.cleaning:
        return Colors.cyan;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Icons.local_gas_station;
      case ExpenseCategory.maintenance:
        return Icons.build;
      case ExpenseCategory.repairs:
        return Icons.build_circle;
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

  void _showExpenseDetails(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.description),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Categoría', expense.category.name),
              _buildDetailRow('Monto', '${expense.amount.toStringAsFixed(2)} ${expense.currency}'),
              _buildDetailRow('Fecha', '${expense.date.day}/${expense.date.month}/${expense.date.year}'),
              if (expense.quantity != null)
                _buildDetailRow('Cantidad', '${expense.quantity!.toStringAsFixed(1)} L'),
              if (expense.unitPrice != null)
                _buildDetailRow('Precio/L', '${expense.unitPrice!.toStringAsFixed(3)} ${expense.currency}'),
              if (expense.odometer != null)
                _buildDetailRow('Odómetro', '${expense.odometer!.toStringAsFixed(0)} km'),
              if (expense.location != null)
                _buildDetailRow('Ubicación', expense.location!),
              if (expense.notes != null)
                _buildDetailRow('Notas', expense.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showOptionsBottomSheet(context, ref);
            },
            child: const Text('Opciones'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar'),
              onTap: () {
                Navigator.pop(context);
                if (onEdit != null) {
                  onEdit!();
                } else {
                  _editExpense(context, ref);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Eliminar'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartir'),
              onTap: () {
                Navigator.pop(context);
                _shareExpense(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editExpense(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Gasto'),
        content: const Text('La función de edición de gastos estará disponible próximamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: Text('¿Estás seguro de que quieres eliminar "${expense.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(expensesNotifierProvider.notifier).deleteExpense(expense.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gasto eliminado'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _shareExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compartir Gasto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selecciona cómo compartir este gasto:'),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copiar al portapapeles'),
              onTap: () {
                Navigator.pop(context);
                final text = '''
Gasto: ${expense.description}
Categoría: ${expense.category.name}
Monto: \$${expense.amount.toStringAsFixed(2)} ${expense.currency}
Fecha: ${expense.date.toString().split(' ')[0]}
${expense.notes != null ? 'Notas: ${expense.notes}\n' : ''}''';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copiado: ${text.substring(0, 50)}...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Compartir por apps'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función de compartir próximamente')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
