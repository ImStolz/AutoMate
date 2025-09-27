import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../models/maintenance_model.dart';
import '../providers/maintenance_provider.dart';

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  const AddMaintenanceScreen({super.key});

  @override
  ConsumerState<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _vehicleNameController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  MaintenanceType _selectedType = MaintenanceType.oilChange;
  bool _isRecurring = false;
  int _recurringInterval = 6;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _vehicleNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mantenimiento'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveMaintenance,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: 'Título del mantenimiento',
                hintText: 'Ej: Cambio de aceite',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _vehicleNameController,
                labelText: 'Nombre del vehículo',
                hintText: 'Ej: Honda Civic 2020',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre del vehículo es requerido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Descripción (opcional)',
                hintText: 'Descripción del mantenimiento',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Tipo de mantenimiento
              Text(
                'Tipo de mantenimiento',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<MaintenanceType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: MaintenanceType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getMaintenanceTypeLabel(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Fecha de vencimiento
              Text(
                'Fecha de vencimiento',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Mantenimiento recurrente
              CheckboxListTile(
                title: const Text('Mantenimiento recurrente'),
                subtitle: const Text('Se repetirá automáticamente'),
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              
              if (_isRecurring) ...[
                const SizedBox(height: 8),
                Text(
                  'Intervalo de repetición (meses)',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _recurringInterval,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  items: [3, 6, 12, 24].map((months) {
                    return DropdownMenuItem(
                      value: months,
                      child: Text('$months meses'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _recurringInterval = value;
                      });
                    }
                  },
                ),
              ],
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _notesController,
                labelText: 'Notas adicionales (opcional)',
                hintText: 'Notas sobre el mantenimiento',
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveMaintenance() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(authNotifierProvider).firebaseUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no autenticado')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final maintenance = MaintenanceModel(
        id: '', // Firestore will generate this
        userId: user.uid,
        vehicleId: 'default', // For now, using default vehicle ID
        vehicleName: _vehicleNameController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        type: _selectedType,
        dueDate: _selectedDate,
        notes: _notesController.text.trim().isEmpty 
            ? null 
            : _notesController.text.trim(),
        isRecurring: _isRecurring,
        recurringInterval: _isRecurring ? _recurringInterval : null,
      );

      await ref.read(maintenanceProvider.notifier).addMaintenance(maintenance);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mantenimiento agregado exitosamente')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar mantenimiento: $e')),
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

  String _getMaintenanceTypeLabel(MaintenanceType type) {
    switch (type) {
      case MaintenanceType.oilChange:
        return 'Cambio de aceite';
      case MaintenanceType.tireRotation:
        return 'Rotación de neumáticos';
      case MaintenanceType.brakeService:
        return 'Servicio de frenos';
      case MaintenanceType.inspection:
        return 'Inspección';
      case MaintenanceType.other:
        return 'Otro';
    }
  }
}
