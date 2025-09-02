import 'package:flutter/material.dart';
import '../../../core/models/vehicle_model.dart';

/// Widget de tarjeta para mostrar información de un vehículo
class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isSelected ? 4 : 2,
      color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con nombre y placa
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.fullName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? theme.colorScheme.primary : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${vehicle.year} • ${vehicle.color}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (vehicle.licensePlate != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  vehicle.licensePlate!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isSelected 
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Imagen del vehículo o icono por defecto
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ) : null,
                    ),
                    child: vehicle.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              vehicle.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            _getVehicleIcon(vehicle.vehicleType),
                            color: isSelected 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 32,
                          ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Métricas principales
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      context,
                      icon: Icons.speed,
                      label: 'Odómetro',
                      value: '${_formatNumber(vehicle.currentOdometer)} km',
                    ),
                  ),
                  Expanded(
                    child: _buildMetric(
                      context,
                      icon: _getFuelIcon(vehicle.fuelType),
                      label: 'Combustible',
                      value: _getFuelLabel(vehicle.fuelType),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      context,
                      icon: Icons.route,
                      label: 'Recorrido',
                      value: '${_formatNumber(vehicle.totalKilometers)} km',
                    ),
                  ),
                  if (vehicle.averageConsumption != null)
                    Expanded(
                      child: _buildMetric(
                        context,
                        icon: Icons.analytics,
                        label: 'Consumo',
                        value: vehicle.isElectric 
                            ? '${vehicle.averageConsumption!.toStringAsFixed(1)} kWh/100km'
                            : '${vehicle.averageConsumption!.toStringAsFixed(1)} L/100km',
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (onSelect != null)
                    TextButton.icon(
                      onPressed: onSelect,
                      icon: Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 16,
                      ),
                      label: Text(isSelected ? 'Seleccionado' : 'Seleccionar'),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  /// Construye un widget de métrica
  Widget _buildMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Formatea números grandes con separadores de miles
  String _formatNumber(double number) {
    return number.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Obtiene el icono según el tipo de vehículo
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

  /// Obtiene el icono según el tipo de combustible
  IconData _getFuelIcon(FuelType type) {
    switch (type) {
      case FuelType.gasoline:
        return Icons.local_gas_station;
      case FuelType.diesel:
        return Icons.local_gas_station;
      case FuelType.electric:
        return Icons.electric_bolt;
      case FuelType.hybrid:
        return Icons.electric_car;
      case FuelType.lpg:
        return Icons.propane_tank;
      case FuelType.cng:
        return Icons.propane_tank;
      case FuelType.other:
        return Icons.local_gas_station;
    }
  }

  /// Obtiene la etiqueta según el tipo de combustible
  String _getFuelLabel(FuelType type) {
    switch (type) {
      case FuelType.gasoline:
        return 'Gasolina';
      case FuelType.diesel:
        return 'Diésel';
      case FuelType.electric:
        return 'Eléctrico';
      case FuelType.hybrid:
        return 'Híbrido';
      case FuelType.lpg:
        return 'GLP';
      case FuelType.cng:
        return 'GNC';
      case FuelType.other:
        return 'Otro';
    }
  }
}
