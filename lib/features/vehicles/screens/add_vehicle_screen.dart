import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/vehicle_brands_data.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../providers/vehicles_provider.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  final VehicleModel? vehicle; // Para editar vehículo existente

  const AddVehicleScreen({super.key, this.vehicle});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _vinController = TextEditingController();
  final _initialOdometerController = TextEditingController();
  final _currentOdometerController = TextEditingController();
  final _tankCapacityController = TextEditingController();
  final _averageConsumptionController = TextEditingController();
  final _notesController = TextEditingController();

  VehicleType _selectedVehicleType = VehicleType.car;
  FuelType _selectedFuelType = FuelType.gasoline;
  bool _isLoading = false;

  List<String> _filteredBrands = [];
  List<String> _filteredModels = [];

  @override
  void initState() {
    super.initState();
    _filteredBrands = VehicleBrandsData.getAllBrands();
    
    if (widget.vehicle != null) {
      _loadVehicleData();
    }
  }

  void _loadVehicleData() {
    final vehicle = widget.vehicle!;
    _brandController.text = vehicle.brand;
    _modelController.text = vehicle.model;
    _yearController.text = vehicle.year.toString();
    _colorController.text = vehicle.color;
    _licensePlateController.text = vehicle.licensePlate ?? '';
    _vinController.text = vehicle.vinNumber ?? '';
    _initialOdometerController.text = vehicle.initialOdometer.toString();
    _currentOdometerController.text = vehicle.currentOdometer.toString();
    _tankCapacityController.text = vehicle.tankCapacity?.toString() ?? '';
    _averageConsumptionController.text = vehicle.averageConsumption?.toString() ?? '';
    _notesController.text = vehicle.notes ?? '';
    _selectedVehicleType = vehicle.vehicleType;
    _selectedFuelType = vehicle.fuelType;
    
    _updateModelsForBrand(vehicle.brand);
  }

  void _updateModelsForBrand(String brand) {
    setState(() {
      _filteredModels = VehicleBrandsData.getModelsForBrand(brand);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Agregar Vehículo' : 'Editar Vehículo'),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildBrandField(),
                    const SizedBox(height: 16),
                    _buildModelField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildYearField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildColorField()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildLicensePlateField(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Tipo y combustible
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo y Combustible',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildVehicleTypeField(),
                    const SizedBox(height: 16),
                    _buildFuelTypeField(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Odómetro
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kilometraje',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildInitialOdometerField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCurrentOdometerField()),
                      ],
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildVinField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildTankCapacityField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildAverageConsumptionField()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildNotesField(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveVehicle,
                    child: Text(widget.vehicle == null ? 'Agregar' : 'Guardar'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandField() {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: _brandController.text),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return _filteredBrands.take(10);
        }
        return _filteredBrands.where((brand) =>
          brand.toLowerCase().contains(textEditingValue.text.toLowerCase())
        ).take(10);
      },
      onSelected: (brand) {
        _brandController.text = brand;
        _updateModelsForBrand(brand);
        _modelController.clear();
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Marca *',
            hintText: 'Ej: Toyota, BMW, Tesla',
            prefixIcon: Icon(Icons.business),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'La marca es requerida';
            }
            return null;
          },
          onChanged: (value) {
            _brandController.text = value;
            if (value.isNotEmpty) {
              _updateModelsForBrand(value);
            }
          },
        );
      },
    );
  }

  Widget _buildModelField() {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: _modelController.text),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return _filteredModels.take(10);
        }
        return _filteredModels.where((model) =>
          model.toLowerCase().contains(textEditingValue.text.toLowerCase())
        ).take(10);
      },
      onSelected: (model) {
        _modelController.text = model;
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Modelo *',
            hintText: 'Ej: Corolla, X3, Model 3',
            prefixIcon: Icon(Icons.directions_car),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El modelo es requerido';
            }
            return null;
          },
          onChanged: (value) {
            _modelController.text = value;
          },
        );
      },
    );
  }

  Widget _buildYearField() {
    return TextFormField(
      controller: _yearController,
      decoration: const InputDecoration(
        labelText: 'Año *',
        hintText: '2020',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El año es requerido';
        }
        final year = int.tryParse(value);
        if (year == null || year < 1900 || year > DateTime.now().year + 1) {
          return 'Año inválido';
        }
        return null;
      },
    );
  }

  Widget _buildColorField() {
    return TextFormField(
      controller: _colorController,
      decoration: const InputDecoration(
        labelText: 'Color *',
        hintText: 'Blanco',
        prefixIcon: Icon(Icons.palette),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El color es requerido';
        }
        return null;
      },
    );
  }

  Widget _buildLicensePlateField() {
    return TextFormField(
      controller: _licensePlateController,
      decoration: const InputDecoration(
        labelText: 'Placa/Matrícula',
        hintText: 'ABC-1234',
        prefixIcon: Icon(Icons.confirmation_number),
      ),
    );
  }

  Widget _buildVehicleTypeField() {
    return DropdownButtonFormField<VehicleType>(
      initialValue: _selectedVehicleType,
      decoration: const InputDecoration(
        labelText: 'Tipo de Vehículo *',
        prefixIcon: Icon(Icons.category),
      ),
      items: VehicleType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(_getVehicleTypeLabel(type)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedVehicleType = value;
          });
        }
      },
    );
  }

  Widget _buildFuelTypeField() {
    return DropdownButtonFormField<FuelType>(
      initialValue: _selectedFuelType,
      decoration: const InputDecoration(
        labelText: 'Tipo de Combustible *',
        prefixIcon: Icon(Icons.local_gas_station),
      ),
      items: FuelType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(_getFuelTypeLabel(type)),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedFuelType = value;
          });
        }
      },
    );
  }

  Widget _buildInitialOdometerField() {
    return TextFormField(
      controller: _initialOdometerController,
      decoration: const InputDecoration(
        labelText: 'Km Inicial *',
        hintText: '0',
        prefixIcon: Icon(Icons.speed),
        suffixText: 'km',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Requerido';
        }
        final km = double.tryParse(value);
        if (km == null || km < 0) {
          return 'Km inválido';
        }
        return null;
      },
    );
  }

  Widget _buildCurrentOdometerField() {
    return TextFormField(
      controller: _currentOdometerController,
      decoration: const InputDecoration(
        labelText: 'Km Actual *',
        hintText: '45000',
        prefixIcon: Icon(Icons.speed),
        suffixText: 'km',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Requerido';
        }
        final km = double.tryParse(value);
        if (km == null || km < 0) {
          return 'Km inválido';
        }
        final initialKm = double.tryParse(_initialOdometerController.text) ?? 0;
        if (km < initialKm) {
          return 'Debe ser ≥ km inicial';
        }
        return null;
      },
    );
  }

  Widget _buildVinField() {
    return TextFormField(
      controller: _vinController,
      decoration: const InputDecoration(
        labelText: 'Número VIN/Bastidor',
        hintText: 'WVWZZZ1JZ3W386752',
        prefixIcon: Icon(Icons.fingerprint),
      ),
    );
  }

  Widget _buildTankCapacityField() {
    return TextFormField(
      controller: _tankCapacityController,
      decoration: InputDecoration(
        labelText: _selectedFuelType == FuelType.electric ? 'Capacidad Batería' : 'Capacidad Tanque',
        hintText: _selectedFuelType == FuelType.electric ? '75' : '50',
        prefixIcon: Icon(_selectedFuelType == FuelType.electric ? Icons.battery_full : Icons.local_gas_station),
        suffixText: _selectedFuelType == FuelType.electric ? 'kWh' : 'L',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildAverageConsumptionField() {
    return TextFormField(
      controller: _averageConsumptionController,
      decoration: InputDecoration(
        labelText: 'Consumo Promedio',
        hintText: _selectedFuelType == FuelType.electric ? '18' : '6.5',
        prefixIcon: const Icon(Icons.analytics),
        suffixText: _selectedFuelType == FuelType.electric ? 'kWh/100km' : 'L/100km',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notas',
        hintText: 'Información adicional sobre el vehículo...',
        prefixIcon: Icon(Icons.notes),
      ),
      maxLines: 3,
    );
  }

  String _getVehicleTypeLabel(VehicleType type) {
    switch (type) {
      case VehicleType.car:
        return 'Automóvil';
      case VehicleType.motorcycle:
        return 'Motocicleta';
      case VehicleType.truck:
        return 'Camión';
      case VehicleType.van:
        return 'Furgoneta';
      case VehicleType.suv:
        return 'SUV';
      case VehicleType.other:
        return 'Otro';
    }
  }

  String _getFuelTypeLabel(FuelType type) {
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

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(currentUserProvider);
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
      final now = DateTime.now();
      final vehicle = VehicleModel(
        id: widget.vehicle?.id ?? '',
        userId: user.id,
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text),
        color: _colorController.text.trim(),
        licensePlate: _licensePlateController.text.trim().isEmpty ? null : _licensePlateController.text.trim(),
        vinNumber: _vinController.text.trim().isEmpty ? null : _vinController.text.trim(),
        vehicleType: _selectedVehicleType,
        fuelType: _selectedFuelType,
        initialOdometer: double.parse(_initialOdometerController.text),
        currentOdometer: double.parse(_currentOdometerController.text),
        tankCapacity: _tankCapacityController.text.trim().isEmpty ? null : double.parse(_tankCapacityController.text),
        averageConsumption: _averageConsumptionController.text.trim().isEmpty ? null : double.parse(_averageConsumptionController.text),
        createdAt: widget.vehicle?.createdAt ?? now,
        updatedAt: now,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      if (widget.vehicle == null) {
        await ref.read(vehiclesNotifierProvider(user.id).notifier).addVehicle(vehicle);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo agregado exitosamente')),
        );
      } else {
        await ref.read(vehiclesNotifierProvider(user.id).notifier).updateVehicle(vehicle);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehículo actualizado exitosamente')),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _licensePlateController.dispose();
    _vinController.dispose();
    _initialOdometerController.dispose();
    _currentOdometerController.dispose();
    _tankCapacityController.dispose();
    _averageConsumptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
