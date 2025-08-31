import 'package:flutter/material.dart';

/// Widget que muestra una lista de los gastos más recientes
class RecentExpensesList extends StatelessWidget {
  const RecentExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // TODO: Reemplazar con datos reales del provider
    final recentExpenses = _getSampleExpenses();
    
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
                    color: expense.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    expense.categoryIcon,
                    color: expense.categoryColor,
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
                            expense.vehicleName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            ' • ${expense.date}',
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
                  expense.amount,
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

  /// Obtiene datos de ejemplo para los gastos recientes
  List<RecentExpenseItem> _getSampleExpenses() {
    return [
      RecentExpenseItem(
        description: 'Combustible Shell',
        vehicleName: 'Toyota Corolla',
        date: 'Hoy',
        amount: '€45.20',
        categoryIcon: Icons.local_gas_station,
        categoryColor: Colors.blue,
      ),
      RecentExpenseItem(
        description: 'Cambio de aceite',
        vehicleName: 'BMW X3',
        date: 'Ayer',
        amount: '€85.00',
        categoryIcon: Icons.build,
        categoryColor: Colors.orange,
      ),
      RecentExpenseItem(
        description: 'Seguro mensual',
        vehicleName: 'Toyota Corolla',
        date: '2 días',
        amount: '€120.00',
        categoryIcon: Icons.security,
        categoryColor: Colors.green,
      ),
      RecentExpenseItem(
        description: 'Combustible Repsol',
        vehicleName: 'BMW X3',
        date: '3 días',
        amount: '€52.80',
        categoryIcon: Icons.local_gas_station,
        categoryColor: Colors.blue,
      ),
    ];
  }
}

/// Clase para representar un elemento de gasto reciente
class RecentExpenseItem {
  final String description;
  final String vehicleName;
  final String date;
  final String amount;
  final IconData categoryIcon;
  final Color categoryColor;

  const RecentExpenseItem({
    required this.description,
    required this.vehicleName,
    required this.date,
    required this.amount,
    required this.categoryIcon,
    required this.categoryColor,
  });
}
