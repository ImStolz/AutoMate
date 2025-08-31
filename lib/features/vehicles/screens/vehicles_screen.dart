import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/add_vehicle_fab.dart';

/// Pantalla de gestión de vehículos
class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    // TODO: Reemplazar con provider real de vehículos
    final vehicles = _getSampleVehicles();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda de vehículos
            },
          ),
        ],
      ),
      body: vehicles.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: () async {
                // TODO: Implementar refresh de vehículos
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: VehicleCard(
                      vehicle: vehicles[index],
                      onTap: () => _navigateToVehicleDetails(context, vehicles[index]),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: const AddVehicleFab(),
    );
  }

  /// Construye el estado vacío cuando no hay vehículos
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_car_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No tienes vehículos registrados',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega tu primer vehículo para comenzar a gestionar gastos y mantenimientos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddVehicle(context),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Vehículo'),
            ),
          ],
        ),
      ),
    );
  }

  /// Navega a los detalles del vehículo
  void _navigateToVehicleDetails(BuildContext context, VehicleItem vehicle) {
    // TODO: Implementar navegación a detalles del vehículo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detalles de ${vehicle.name}'),
      ),
    );
  }

  /// Navega a la pantalla de agregar vehículo
  void _navigateToAddVehicle(BuildContext context) {
    // TODO: Implementar navegación a agregar vehículo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Agregar nuevo vehículo'),
      ),
    );
  }

  /// Obtiene datos de ejemplo para los vehículos
  List<VehicleItem> _getSampleVehicles() {
    return [
      VehicleItem(
        id: '1',
        name: 'Toyota Corolla',
        year: 2020,
        color: 'Blanco',
        licensePlate: 'ABC-1234',
        fuelType: 'Gasolina',
        currentOdometer: 45000,
        averageConsumption: 6.8,
        imageUrl: null,
        lastExpenseDate: 'Hace 2 días',
        totalExpensesThisMonth: 245.50,
        nextMaintenanceKm: 50000,
        nextMaintenanceType: 'Cambio de aceite',
      ),
      VehicleItem(
        id: '2',
        name: 'BMW X3',
        year: 2019,
        color: 'Negro',
        licensePlate: 'XYZ-5678',
        fuelType: 'Diesel',
        currentOdometer: 78000,
        averageConsumption: 7.2,
        imageUrl: null,
        lastExpenseDate: 'Ayer',
        totalExpensesThisMonth: 320.80,
        nextMaintenanceKm: 80000,
        nextMaintenanceType: 'Revisión técnica',
      ),
    ];
  }
}

/// Clase para representar un vehículo en la lista
class VehicleItem {
  final String id;
  final String name;
  final int year;
  final String color;
  final String licensePlate;
  final String fuelType;
  final double currentOdometer;
  final double averageConsumption;
  final String? imageUrl;
  final String lastExpenseDate;
  final double totalExpensesThisMonth;
  final double nextMaintenanceKm;
  final String nextMaintenanceType;

  const VehicleItem({
    required this.id,
    required this.name,
    required this.year,
    required this.color,
    required this.licensePlate,
    required this.fuelType,
    required this.currentOdometer,
    required this.averageConsumption,
    this.imageUrl,
    required this.lastExpenseDate,
    required this.totalExpensesThisMonth,
    required this.nextMaintenanceKm,
    required this.nextMaintenanceType,
  });
}
