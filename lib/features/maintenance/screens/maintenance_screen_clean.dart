import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/premium_badge.dart';
import '../models/maintenance_model.dart';
import '../providers/maintenance_provider.dart';

/// Pantalla de gestión de mantenimientos
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final maintenanceAsync = ref.watch(maintenanceStreamProvider);
    
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
      body: maintenanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (maintenanceData) {
          final upcomingMaintenance = maintenanceData
              .where((m) => m.dueDate.isAfter(DateTime.now()))
              .toList()
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
          
          final completedMaintenance = maintenanceData
              .where((m) => m.completedDate != null)
              .toList()
            ..sort((a, b) => 
                (b.completedDate ?? DateTime.now())
                .compareTo(a.completedDate ?? DateTime.now()));
          
          return _buildMaintenanceContent(
            context,
            theme,
            upcomingMaintenance,
            completedMaintenance,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMaintenance(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMaintenanceContent(
    BuildContext context,
    ThemeData theme,
    List<MaintenanceModel> upcomingMaintenance,
    List<MaintenanceModel> completedMaintenance,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upcoming Maintenance Section
          const Text(
            'Próximos Mantenimientos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (upcomingMaintenance.isEmpty)
            const EmptyState(message: 'No hay mantenimientos programados')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingMaintenance.length,
              itemBuilder: (context, index) => _buildUpcomingMaintenanceItem(
                context,
                theme,
                upcomingMaintenance[index],
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Completed Maintenance Section
          const Text(
            'Mantenimientos Completados',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (completedMaintenance.isEmpty)
            const EmptyState(message: 'No hay mantenimientos completados')
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: completedMaintenance.length,
              itemBuilder: (context, index) => _buildCompletedMaintenanceItem(
                context,
                theme,
                completedMaintenance[index],
              ),
            ),
        ],
      ),
    );
  }

  // Show calendar view dialog
  void _showCalendarView(BuildContext context) {
    // TODO: Implement calendar view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vista de calendario no implementada')),
    );
  }

  // Show filters dialog
  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Filtrar por',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Por Fecha'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement date filter
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
              // TODO: Implement type filter
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filtro por tipo aplicado')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text('Cerrar'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Navigate to add maintenance screen
  void _addMaintenance(BuildContext context) {
    context.go('/add-maintenance');
  }

  // Complete a maintenance task
  void _completeMaintenance(BuildContext context, String maintenanceId) {
    showDialog(
      context: context,
      builder: (context) => _CompleteMaintenanceDialog(maintenanceId: maintenanceId),
    );
  }

  // Build maintenance item for upcoming maintenance
  Widget _buildUpcomingMaintenanceItem(
    BuildContext context,
    ThemeData theme,
    MaintenanceModel maintenance,
  ) {
    final daysUntilDue = maintenance.dueDate.difference(DateTime.now()).inDays;
    final isDueSoon = daysUntilDue <= 7;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMaintenanceColor(maintenance.type).withOpacity(0.1),
          child: Icon(
            _getMaintenanceIcon(maintenance.type),
            color: _getMaintenanceColor(maintenance.type),
          ),
        ),
        title: Text(maintenance.title),
        subtitle: Text(
          '${maintenance.vehicleName ?? 'Vehículo'} • ' 
          'Vence en $daysUntilDue días',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle_outline),
          onPressed: () => _completeMaintenance(context, maintenance.id),
        ),
        onTap: () => _showMaintenanceDetails(context, maintenance),
      ),
    );
  }

  // Build completed maintenance item
  Widget _buildCompletedMaintenanceItem(
    BuildContext context,
    ThemeData theme,
    MaintenanceModel maintenance,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: const Icon(Icons.check_circle, color: Colors.green),
        ),
        title: Text(maintenance.title),
        subtitle: Text(
          '${maintenance.vehicleName ?? 'Vehículo'} • ' 
          'Completado el ${DateFormat('dd/MM/yyyy').format(maintenance.completedDate!)}',
        ),
        trailing: Text(
          '${maintenance.cost?.toStringAsFixed(2) ?? '0.00'} €',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () => _showMaintenanceDetails(context, maintenance),
      ),
    );
  }

  // Show maintenance details dialog
  void _showMaintenanceDetails(BuildContext context, MaintenanceModel maintenance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(maintenance.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Vehículo', maintenance.vehicleName ?? 'No especificado'),
            _buildDetailRow('Tipo', maintenance.type.toString().split('.').last),
            _buildDetailRow(
              'Fecha de vencimiento', 
              DateFormat('dd/MM/yyyy').format(maintenance.dueDate),
            ),
            if (maintenance.completedDate != null)
              _buildDetailRow(
                'Completado el', 
                DateFormat('dd/MM/yyyy').format(maintenance.completedDate!),
              ),
            if (maintenance.odometer != null)
              _buildDetailRow('Kilómetros', '${maintenance.odometer} km'),
            if (maintenance.cost != null)
              _buildDetailRow('Costo', '${maintenance.cost?.toStringAsFixed(2)} €'),
            if (maintenance.notes?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              const Text('Notas:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(maintenance.notes!), 
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  // Helper methods
  String _getDueDateText(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(DateTime(now.year, now.month, now.day));
    
    if (difference.inDays == 0) return 'Hoy';
    if (difference.inDays == 1) return 'Mañana';
    if (difference.inDays < 7) return 'En ${difference.inDays} días';
    
    final weeks = (difference.inDays / 7).floor();
    return weeks == 1 ? 'En 1 semana' : 'En $weeks semanas';
  }

  IconData _getMaintenanceIcon(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.oilChange:
        return Icons.oil_barrel;
      case MaintenanceType.tireRotation:
        return Icons.sync_alt;
      case MaintenanceType.brakeService:
        return Icons.warning;
      case MaintenanceType.inspection:
        return Icons.search;
      case MaintenanceType.other:
      default:
        return Icons.build;
    }
  }

  Color _getMaintenanceColor(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.oilChange:
        return Colors.orange;
      case MaintenanceType.tireRotation:
        return Colors.blue;
      case MaintenanceType.brakeService:
        return Colors.red;
      case MaintenanceType.inspection:
        return Colors.purple;
      case MaintenanceType.other:
      default:
        return Colors.grey;
    }
  }
}

/// Dialog para completar un mantenimiento
class _CompleteMaintenanceDialog extends ConsumerStatefulWidget {
  final String maintenanceId;

  const _CompleteMaintenanceDialog({required this.maintenanceId});

  @override
  ConsumerState<_CompleteMaintenanceDialog> createState() => _CompleteMaintenanceDialogState();
}

class _CompleteMaintenanceDialogState extends ConsumerState<_CompleteMaintenanceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _odometerController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _costController.dispose();
    _odometerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Completar Mantenimiento'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Costo (€)',
                  prefixText: '€ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El costo es requerido';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _odometerController,
                decoration: const InputDecoration(
                  labelText: 'Kilómetros actuales',
                  suffixText: 'km',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Los kilómetros son requeridos';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _completeMaintenance,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Completar'),
        ),
      ],
    );
  }

  Future<void> _completeMaintenance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final cost = double.parse(_costController.text);
      final odometer = int.parse(_odometerController.text);
      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

      await ref.read(maintenanceProvider.notifier).completeMaintenance(
        widget.maintenanceId,
        cost: cost,
        odometer: odometer,
        notes: notes,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mantenimiento completado exitosamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al completar mantenimiento: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
