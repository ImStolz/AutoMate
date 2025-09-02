import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vehicles_provider.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_selector.dart';

/// Pantalla de gestión de vehículos
class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final vehiclesState = ref.watch(vehiclesNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
        actions: [
          const VehicleSelector(),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementar búsqueda de vehículos
            },
          ),
        ],
      ),
      body: vehiclesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vehiclesState.error != null
              ? _buildErrorState(context, vehiclesState.error!, ref, user.id)
          : vehiclesState.vehicles.isEmpty
              ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: () => ref.read(vehiclesNotifierProvider.notifier).loadVehicles(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehiclesState.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehiclesState.vehicles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: VehicleCard(
                      vehicle: vehicle,
                      isSelected: vehiclesState.selectedVehicle?.id == vehicle.id,
                      onTap: () => _navigateToVehicleDetails(context, vehicle.id),
                      onSelect: () => ref.read(vehiclesNotifierProvider.notifier).selectVehicle(vehicle),
                      onEdit: () => _navigateToEditVehicle(context, vehicle.id),
                      onDelete: () => _showDeleteDialog(context, ref, user.id, vehicle),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddVehicle(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar Vehículo'),
      ),
    );
  }

  /// Construye el estado de error
  Widget _buildErrorState(BuildContext context, String error, WidgetRef ref, String userId) {
    final theme = Theme.of(context);
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar vehículos',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ref.read(vehiclesNotifierProvider.notifier).loadVehicles(),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
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
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
  void _navigateToVehicleDetails(BuildContext context, String vehicleId) {
    // TODO: Implementar navegación a detalles del vehículo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Detalles del vehículo: $vehicleId'),
      ),
    );
  }

  /// Navega a la pantalla de agregar vehículo
  void _navigateToAddVehicle(BuildContext context) {
    Navigator.of(context).pushNamed('/add-vehicle');
  }

  /// Navega a la pantalla de editar vehículo
  void _navigateToEditVehicle(BuildContext context, String vehicleId) {
    Navigator.of(context).pushNamed('/edit-vehicle', arguments: vehicleId);
  }

  /// Muestra el diálogo de confirmación para eliminar vehículo
  void _showDeleteDialog(BuildContext context, WidgetRef ref, String userId, VehicleModel vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Vehículo'),
          content: Text(
            '¿Estás seguro de que deseas eliminar ${vehicle.fullName}? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(vehiclesNotifierProvider.notifier).deleteVehicle(vehicle.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${vehicle.fullName} eliminado'),
                    action: SnackBarAction(
                      label: 'Deshacer',
                      onPressed: () {
                        // TODO: Implementar deshacer eliminación
                      },
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

}
