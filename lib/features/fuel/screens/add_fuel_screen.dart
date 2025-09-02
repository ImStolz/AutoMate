import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/providers/expenses_provider.dart';
import '../../../core/providers/vehicles_provider.dart';
import '../../../core/providers/auth_provider.dart';

/// Pantalla para agregar una nueva carga de combustible
class AddFuelScreen extends ConsumerStatefulWidget {
  const AddFuelScreen({super.key});

  @override
  ConsumerState<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends ConsumerState<AddFuelScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _odometerController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedVehicleId;
  String _selectedCurrency = 'EUR';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = 'Carga de combustible';
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _odometerController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehiclesState = ref.watch(vehiclesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Combustible'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveFuelEntry,
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Selección de vehículo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehículo',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedVehicleId,
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar vehículo',
                        border: OutlineInputBorder(),
                      ),
                      items: vehiclesState.vehicles.map((vehicle) {
                        return DropdownMenuItem(
                          value: vehicle.id,
                          child: Text(vehicle.fullName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedVehicleId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Selecciona un vehículo';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Información básica
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Básica',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Fecha
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Fecha'),
                      subtitle: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _selectDate,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Descripción
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa una descripción';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Detalles del combustible
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalles del Combustible',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(
                              labelText: 'Cantidad (L)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.local_gas_station),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: _calculateTotal,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa la cantidad';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Ingresa un número válido';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _unitPriceController,
                            decoration: const InputDecoration(
                              labelText: 'Precio/L (€)',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.euro),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: _calculateTotal,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingresa el precio';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Ingresa un número válido';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Total (€)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el monto total';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Ingresa un número válido';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Información adicional
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Información Adicional',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _odometerController,
                      decoration: const InputDecoration(
                        labelText: 'Odómetro (km)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.speed),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación (opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notas (opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _calculateTotal(String value) {
    final quantity = double.tryParse(_quantityController.text);
    final unitPrice = double.tryParse(_unitPriceController.text);
    
    if (quantity != null && unitPrice != null) {
      final total = quantity * unitPrice;
      _amountController.text = total.toStringAsFixed(2);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveFuelEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Usuario no autenticado');

      final expense = ExpenseModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        vehicleId: _selectedVehicleId!,
        userId: user.id,
        category: ExpenseCategory.fuel,
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        currency: _selectedCurrency,
        date: _selectedDate,
        odometer: double.tryParse(_odometerController.text),
        quantity: double.tryParse(_quantityController.text),
        unitPrice: double.tryParse(_unitPriceController.text),
        location: _locationController.text.isEmpty ? null : _locationController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await ref.read(expensesNotifierProvider.notifier).addExpense(expense);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carga de combustible guardada'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
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
