import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../providers/vehicles_provider.dart';

class VehicleSelector extends ConsumerWidget {
  const VehicleSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final vehiclesState = ref.watch(vehiclesNotifierProvider(user.id));
    final selectedVehicle = vehiclesState.selectedVehicle;
    final vehicles = vehiclesState.vehicles;

    if (vehicles.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<VehicleModel>(
      onSelected: (vehicle) {
        ref.read(vehiclesNotifierProvider(user.id).notifier).selectVehicle(vehicle);
      },
      itemBuilder: (context) {
        return vehicles.map((vehicle) {
          return PopupMenuItem<VehicleModel>(
            value: vehicle,
            child: Row(
              children: [
                Icon(
                  _getVehicleIcon(vehicle.vehicleType),
                  size: 20,
                  color: selectedVehicle?.id == vehicle.id 
                      ? Theme.of(context).colorScheme.primary 
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${vehicle.brand} ${vehicle.model}',
                        style: TextStyle(
                          fontWeight: selectedVehicle?.id == vehicle.id 
                              ? FontWeight.bold 
                              : FontWeight.normal,
                          color: selectedVehicle?.id == vehicle.id 
                              ? Theme.of(context).colorScheme.primary 
                              : null,
                        ),
                      ),
                      if (vehicle.licensePlate != null)
                        Text(
                          vehicle.licensePlate!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                if (selectedVehicle?.id == vehicle.id)
                  Icon(
                    Icons.check,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selectedVehicle != null 
                  ? _getVehicleIcon(selectedVehicle.vehicleType)
                  : Icons.directions_car,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            if (selectedVehicle != null) ...[
              Text(
                '${selectedVehicle.brand} ${selectedVehicle.model}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getVehicleIcon(VehicleType type) {
    switch (type) {
      case VehicleType.car:
        return Icons.directions_car;
      case VehicleType.motorcycle:
        return Icons.two_wheeler;
      case VehicleType.truck:
        return Icons.local_shipping;
      case VehicleType.van:
        return Icons.airport_shuttle;
      case VehicleType.suv:
        return Icons.directions_car;
      case VehicleType.other:
        return Icons.directions_car;
    }
  }
}
