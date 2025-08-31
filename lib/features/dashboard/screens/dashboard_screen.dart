import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/expense_chart.dart';
import '../widgets/recent_expenses_list.dart';
import '../widgets/maintenance_reminders.dart';

/// Pantalla principal del dashboard con resumen de gastos y estadísticas
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
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
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar notificaciones
            },
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
                      value: '2', // TODO: Obtener de provider
                      subtitle: 'Registrados',
                      icon: Icons.directions_car,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Este mes',
                      value: '€245.50', // TODO: Obtener de provider
                      subtitle: 'Gastos totales',
                      icon: Icons.euro,
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
                      value: '6.8 L/100km', // TODO: Obtener de provider
                      subtitle: 'Consumo',
                      icon: Icons.local_gas_station,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DashboardCard(
                      title: 'Próximo',
                      value: '2,500 km', // TODO: Obtener de provider
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
                      // TODO: Navegar a pantalla de gastos
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
                // TODO: Navegar a registro de combustible
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Agregar gasto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a registro de gasto
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Registrar mantenimiento'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a registro de mantenimiento
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Agregar vehículo'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a registro de vehículo
              },
            ),
          ],
        ),
      ),
    );
  }
}
