import 'package:flutter/material.dart';

/// Floating Action Button para agregar un nuevo vehículo
class AddVehicleFab extends StatelessWidget {
  const AddVehicleFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddVehicleDialog(context),
      icon: const Icon(Icons.add),
      label: const Text('Agregar Vehículo'),
    );
  }

  /// Muestra el diálogo para agregar un nuevo vehículo
  void _showAddVehicleDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Título
              Text(
                'Agregar Vehículo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Opciones de agregar vehículo
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildOptionTile(
                      context,
                      icon: Icons.edit,
                      title: 'Agregar manualmente',
                      subtitle: 'Ingresa los datos de tu vehículo',
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToManualAdd(context);
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildOptionTile(
                      context,
                      icon: Icons.qr_code_scanner,
                      title: 'Escanear matrícula',
                      subtitle: 'Usa la cámara para escanear la placa',
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToScanLicense(context);
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildOptionTile(
                      context,
                      icon: Icons.search,
                      title: 'Buscar por VIN',
                      subtitle: 'Ingresa el número de bastidor',
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToVinSearch(context);
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Información sobre límites
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Plan Gratuito',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Puedes registrar hasta 2 vehículos gratis. Actualiza a Premium para vehículos ilimitados.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToUpgrade(context);
                            },
                            child: const Text('Ver planes Premium'),
                          ),
                        ],
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

  /// Construye una opción del menú
  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  /// Navega a la pantalla de agregar manualmente
  void _navigateToManualAdd(BuildContext context) {
    // TODO: Implementar navegación a formulario manual
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Agregar vehículo manualmente')),
    );
  }

  /// Navega a la pantalla de escanear matrícula
  void _navigateToScanLicense(BuildContext context) {
    // TODO: Implementar escáner de matrícula
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Escanear matrícula')),
    );
  }

  /// Navega a la pantalla de búsqueda por VIN
  void _navigateToVinSearch(BuildContext context) {
    // TODO: Implementar búsqueda por VIN
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Buscar por VIN')),
    );
  }

  /// Navega a la pantalla de upgrade
  void _navigateToUpgrade(BuildContext context) {
    // TODO: Implementar navegación a planes Premium
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ver planes Premium')),
    );
  }
}
