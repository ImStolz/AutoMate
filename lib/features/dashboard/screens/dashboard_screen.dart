import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vehicles_provider.dart';
import '../../../core/providers/expenses_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/expense_chart.dart';
import '../widgets/recent_expenses_list.dart';
import '../widgets/maintenance_reminders.dart';
import '../widgets/currency_selector.dart';
import '../../vehicles/widgets/vehicle_selector.dart';

/// Pantalla principal del dashboard con resumen de gastos y estadísticas
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final vehiclesState = ref.watch(vehiclesNotifierProvider);
    final expensesState = ref.watch(expensesNotifierProvider);
    final currencyNotifier = ref.watch(currencyNotifierProvider.notifier);
    final selectedCurrency = ref.watch(currencyNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${user?.displayName.split(' ').first ?? 'Usuario'}',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Resumen de tus vehículos',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          const VehicleSelector(),
          const SizedBox(width: 8),
          const CurrencySelector(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Implementar refresh de datos
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjetas de resumen
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Vehículos',
                      value: '${vehiclesState.vehicles.length}',
                      subtitle: 'Registrados',
                      icon: Icons.directions_car,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Este mes',
                      value: _getCurrentMonthTotal(expensesState, currencyNotifier),
                      subtitle: 'Gastos totales',
                      icon: _getCurrencyIcon(selectedCurrency.code),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Promedio',
                      value: _getAverageConsumption(expensesState),
                      subtitle: 'Consumo',
                      icon: Icons.local_gas_station,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Próximo',
                      value: _getNextMaintenance(vehiclesState),
                      subtitle: 'Mantenimiento',
                      icon: Icons.build,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Gráfico de gastos
              Text(
                'Gastos de los últimos 6 meses',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const ExpenseChart(),
              
              const SizedBox(height: 24),
              
              // Recordatorios de mantenimiento
              Text(
                'Recordatorios de mantenimiento',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const MaintenanceReminders(),
              
              const SizedBox(height: 24),
              
              // Gastos recientes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gastos recientes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/expenses');
                    },
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const RecentExpensesList(),
              
              const SizedBox(height: 100), // Espacio para el bottom nav
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Mostrar menú de acciones rápidas
          _showQuickActionsMenu(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Muestra el menú de acciones rápidas
  void _showQuickActionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Acciones rápidas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Registrar combustible'),
              onTap: () {
                Navigator.pop(context);
                context.push('/expenses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Agregar gasto'),
              onTap: () {
                Navigator.pop(context);
                context.push('/expenses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Registrar mantenimiento'),
              onTap: () {
                Navigator.pop(context);
                context.push('/maintenance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Agregar vehículo'),
              onTap: () {
                Navigator.pop(context);
                context.push('/vehicles');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications),
                const SizedBox(width: 8),
                Text(
                  'Notificaciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // TODO: Implementar notificaciones reales basadas en datos del usuario
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sin notificaciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Las notificaciones aparecerán aquí',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Obtiene el total de gastos del mes actual
  String _getCurrentMonthTotal(ExpensesState expensesState, CurrencyNotifier currencyNotifier) {
    if (expensesState.expenses.isEmpty) return currencyNotifier.formatAmount(0.0);
    
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);
    
    final monthlyExpenses = expensesState.expenses.where((expense) =>
        expense.date.isAfter(currentMonth.subtract(const Duration(days: 1))) &&
        expense.date.isBefore(nextMonth));
    
    final total = monthlyExpenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    return currencyNotifier.formatAmount(total);
  }

  /// Obtiene el promedio de consumo
  String _getAverageConsumption(ExpensesState expensesState) {
    if (expensesState.expenses.isEmpty) return '0.0 L/100km';
    
    final fuelExpenses = expensesState.expenses.where((expense) => 
        expense.category.name == 'fuel' && expense.quantity != null);
    
    if (fuelExpenses.isEmpty) return '0.0 L/100km';
    
    final totalLiters = fuelExpenses.fold<double>(0, (sum, expense) => sum + (expense.quantity ?? 0));
    final avgConsumption = totalLiters / fuelExpenses.length;
    return '${avgConsumption.toStringAsFixed(1)} L/100km';
  }

  /// Obtiene el próximo mantenimiento
  String _getNextMaintenance(VehiclesState vehiclesState) {
    if (vehiclesState.vehicles.isEmpty) return 'Sin datos';
    
    // Simulación simple - en producción esto vendría de datos reales
    final vehicle = vehiclesState.vehicles.first;
    final nextService = vehicle.currentOdometer + 5000;
    return '${nextService.toStringAsFixed(0)} km';
  }

  /// Obtiene el icono apropiado para la moneda
  IconData _getCurrencyIcon(String currencyCode) {
    switch (currencyCode) {
      case 'EUR':
        return Icons.euro;
      case 'USD':
      case 'CLP':
      case 'COP':
      case 'MXN':
      case 'ARS':
      case 'CAD':
        return Icons.attach_money;
      case 'GBP':
        return Icons.currency_pound;
      case 'JPY':
        return Icons.currency_yen;
      default:
        return Icons.attach_money;
    }
  }
}
