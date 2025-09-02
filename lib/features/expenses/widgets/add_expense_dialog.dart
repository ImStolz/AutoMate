import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/models/vehicle_model.dart';

/// Diálogo para agregar un nuevo gasto
class AddExpenseDialog extends StatefulWidget {
  final String userId;
  final List<VehicleModel> vehicles;
  final Function(ExpenseModel) onExpenseAdded;

  const AddExpenseDialog({
    super.key,
    required this.userId,
    required this.vehicles,
    required this.onExpenseAdded,
  });

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _odometerController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  ExpenseCategory _selectedCategory = ExpenseCategory.fuel;
  String _selectedCurrency = 'EUR';
  VehicleModel? _selectedVehicle;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.vehicles.isNotEmpty) {
      _selectedVehicle = widget.vehicles.first;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _odometerController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Agregar Gasto',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vehículo
                      if (widget.vehicles.isNotEmpty) ...[
                        Text(
                          'Vehículo',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<VehicleModel>(
                          initialValue: _selectedVehicle,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_car),
                          ),
                          items: widget.vehicles.map((vehicle) {
                            return DropdownMenuItem(
                              value: vehicle,
                              child: Text('${vehicle.brand} ${vehicle.model} - ${vehicle.licensePlate}'),
                            );
                          }).toList(),
                          onChanged: (vehicle) {
                            setState(() {
                              _selectedVehicle = vehicle;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Selecciona un vehículo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Categoría
                      Text(
                        'Categoría',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ExpenseCategory>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: ExpenseCategory.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(category),
                                  size: 18,
                                  color: _getCategoryColor(category),
                                ),
                                const SizedBox(width: 8),
                                Text(_getCategoryName(category)),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (category) {
                          setState(() {
                            _selectedCategory = category!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descripción
                      Text(
                        'Descripción',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          hintText: 'Ej: Gasolina Shell',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa una descripción';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Monto y Moneda
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monto',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _amountController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.euro),
                                    hintText: '0.00',
                                  ),
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingresa el monto';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Monto inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Moneda',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCurrency,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                                    DropdownMenuItem(value: 'COP', child: Text('COP')),
                                    DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                                  ],
                                  onChanged: (currency) {
                                    setState(() {
                                      _selectedCurrency = currency!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Fecha
                      Text(
                        'Fecha',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Información adicional para combustible
                      if (_selectedCategory == ExpenseCategory.fuel) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cantidad (L)',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _quantityController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.local_gas_station),
                                      hintText: '0.0',
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Precio/L',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _unitPriceController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.euro),
                                      hintText: '0.00',
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Odómetro
                      Text(
                        'Odómetro (km)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _odometerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.speed),
                          hintText: 'Kilometraje actual',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Ubicación
                      Text(
                        'Ubicación',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                          hintText: 'Ej: Shell - Av. Principal',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Notas
                      Text(
                        'Notas',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.notes),
                          hintText: 'Notas adicionales...',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _saveExpense,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un vehículo')),
      );
      return;
    }

    final expense = ExpenseModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      vehicleId: _selectedVehicle!.id,
      userId: widget.userId,
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      amount: double.parse(_amountController.text),
      currency: _selectedCurrency,
      date: _selectedDate,
      odometer: _odometerController.text.isNotEmpty 
          ? double.parse(_odometerController.text) 
          : null,
      quantity: _quantityController.text.isNotEmpty 
          ? double.parse(_quantityController.text) 
          : null,
      unitPrice: _unitPriceController.text.isNotEmpty 
          ? double.parse(_unitPriceController.text) 
          : null,
      location: _locationController.text.isNotEmpty 
          ? _locationController.text.trim() 
          : null,
      notes: _notesController.text.isNotEmpty 
          ? _notesController.text.trim() 
          : null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onExpenseAdded(expense);
    Navigator.of(context).pop();
  }

  String _getCategoryName(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return 'Combustible';
      case ExpenseCategory.maintenance:
        return 'Mantenimiento';
      case ExpenseCategory.repairs:
        return 'Reparaciones';
      case ExpenseCategory.insurance:
        return 'Seguro';
      case ExpenseCategory.registration:
        return 'Registro';
      case ExpenseCategory.parking:
        return 'Estacionamiento';
      case ExpenseCategory.tolls:
        return 'Peajes';
      case ExpenseCategory.accessories:
        return 'Accesorios';
      case ExpenseCategory.cleaning:
        return 'Limpieza';
      case ExpenseCategory.other:
        return 'Otros';
    }
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Icons.local_gas_station;
      case ExpenseCategory.maintenance:
        return Icons.build;
      case ExpenseCategory.repairs:
        return Icons.handyman;
      case ExpenseCategory.insurance:
        return Icons.security;
      case ExpenseCategory.registration:
        return Icons.description;
      case ExpenseCategory.parking:
        return Icons.local_parking;
      case ExpenseCategory.tolls:
        return Icons.toll;
      case ExpenseCategory.accessories:
        return Icons.shopping_bag;
      case ExpenseCategory.cleaning:
        return Icons.local_car_wash;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Colors.red;
      case ExpenseCategory.maintenance:
        return Colors.blue;
      case ExpenseCategory.repairs:
        return Colors.orange;
      case ExpenseCategory.insurance:
        return Colors.green;
      case ExpenseCategory.registration:
        return Colors.purple;
      case ExpenseCategory.parking:
        return Colors.teal;
      case ExpenseCategory.tolls:
        return Colors.brown;
      case ExpenseCategory.accessories:
        return Colors.pink;
      case ExpenseCategory.cleaning:
        return Colors.cyan;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }
}
