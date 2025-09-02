import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/premium_badge.dart';

/// Pantalla de gestión de mantenimientos
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Mantenimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showCalendarView(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
      ),
      body: _buildMaintenanceContent(context, theme),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMaintenance(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMaintenanceContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Próximos mantenimientos
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Próximos Mantenimientos',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMaintenanceItem(
                    context,
                    'Cambio de aceite',
                    'Toyota Corolla 2020',
                    'En 500 km',
                    Colors.orange,
                    Icons.oil_barrel,
                  ),
                  const Divider(),
                  _buildMaintenanceItem(
                    context,
                    'Revisión general',
                    'Honda Civic 2019',
                    'En 15 días',
                    Colors.blue,
                    Icons.build,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Historial de mantenimientos
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Historial Reciente',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildMaintenanceHistoryItem(
                    context,
                    'Cambio de filtro de aire',
                    'Toyota Corolla 2020',
                    'Hace 2 semanas',
                    '\$25.00',
                    Colors.green,
                  ),
                  const Divider(),
                  _buildMaintenanceHistoryItem(
                    context,
                    'Rotación de llantas',
                    'Honda Civic 2019',
                    'Hace 1 mes',
                    '\$40.00',
                    Colors.blue,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Funciones premium
          const PremiumLockWidget(
            feature: 'Recordatorios Automáticos',
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceItem(
    BuildContext context,
    String title,
    String vehicle,
    String timeLeft,
    Color color,
    IconData icon,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(vehicle),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            timeLeft,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      onTap: () => _showMaintenanceDetails(context, title),
    );
  }

  Widget _buildMaintenanceHistoryItem(
    BuildContext context,
    String title,
    String vehicle,
    String date,
    String cost,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(Icons.check_circle, color: color),
      ),
      title: Text(title),
      subtitle: Text('$vehicle • $date'),
      trailing: Text(
        cost,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => _showMaintenanceDetails(context, title),
    );
  }

  void _showCalendarView(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vista de Calendario'),
        content: const Text('Próximamente podrás ver todos tus mantenimientos en un calendario interactivo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtros de Mantenimiento',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Por Vehículo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filtro por vehículo aplicado')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Por Fecha'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filtro por fecha aplicado')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Por Tipo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filtro por tipo aplicado')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addMaintenance(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Mantenimiento'),
        content: const Text('¿Qué tipo de mantenimiento deseas agregar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddMaintenanceForm(context);
            },
            child: const Text('Programar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAddCompletedMaintenanceForm(context);
            },
            child: const Text('Registrar Completado'),
          ),
        ],
      ),
    );
  }

  void _showAddMaintenanceForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Programar Mantenimiento'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tipo de mantenimiento',
                  hintText: 'Ej: Cambio de aceite',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Vehículo',
                  hintText: 'Seleccionar vehículo',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Fecha programada',
                  hintText: 'DD/MM/AAAA',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Kilometraje objetivo',
                  hintText: 'Ej: 50000',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mantenimiento programado exitosamente')),
              );
            },
            child: const Text('Programar'),
          ),
        ],
      ),
    );
  }

  void _showAddCompletedMaintenanceForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Mantenimiento Completado'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tipo de mantenimiento',
                  hintText: 'Ej: Cambio de aceite',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Vehículo',
                  hintText: 'Seleccionar vehículo',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Fecha realizada',
                  hintText: 'DD/MM/AAAA',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Costo',
                  hintText: '\$0.00',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Kilometraje actual',
                  hintText: 'Ej: 48500',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notas',
                  hintText: 'Detalles adicionales...',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mantenimiento registrado exitosamente')),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceDetails(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Vehículo: Toyota Corolla 2020'),
            const SizedBox(height: 8),
            const Text('Fecha programada: 15/03/2024'),
            const SizedBox(height: 8),
            const Text('Kilometraje objetivo: 50,000 km'),
            const SizedBox(height: 8),
            const Text('Costo estimado: \$75.00'),
            const SizedBox(height: 16),
            const Text('Notas:'),
            const Text('Cambio de aceite sintético 5W-30'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mantenimiento marcado como completado')),
              );
            },
            child: const Text('Marcar Completado'),
          ),
        ],
      ),
    );
  }
}
