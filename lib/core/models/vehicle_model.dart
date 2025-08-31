import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

/// Modelo de datos para vehículos registrados por el usuario
/// Soporta tanto vehículos de combustión como eléctricos
@JsonSerializable()
class VehicleModel extends Equatable {
  /// ID único del vehículo
  final String id;
  
  /// ID del usuario propietario
  final String userId;
  
  /// Marca del vehículo (ej: Toyota, BMW, Tesla)
  final String brand;
  
  /// Modelo del vehículo (ej: Corolla, X3, Model 3)
  final String model;
  
  /// Año de fabricación
  final int year;
  
  /// Color del vehículo
  final String color;
  
  /// Número de placa/matrícula
  final String? licensePlate;
  
  /// Número de bastidor/VIN
  final String? vinNumber;
  
  /// Tipo de vehículo
  final VehicleType vehicleType;
  
  /// Tipo de combustible/energía
  final FuelType fuelType;
  
  /// Odómetro inicial al registrar el vehículo (en km)
  final double initialOdometer;
  
  /// Odómetro actual (en km)
  final double currentOdometer;
  
  /// Capacidad del tanque/batería
  final double? tankCapacity;
  
  /// Consumo promedio (L/100km para combustión, kWh/100km para eléctrico)
  final double? averageConsumption;
  
  /// URL de la imagen del vehículo
  final String? imageUrl;
  
  /// Fecha de registro del vehículo
  final DateTime createdAt;
  
  /// Última actualización
  final DateTime updatedAt;
  
  /// Si el vehículo está activo (no vendido/dado de baja)
  final bool isActive;
  
  /// Notas adicionales del vehículo
  final String? notes;

  const VehicleModel({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    this.licensePlate,
    this.vinNumber,
    required this.vehicleType,
    required this.fuelType,
    required this.initialOdometer,
    required this.currentOdometer,
    this.tankCapacity,
    this.averageConsumption,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.notes,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => 
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  VehicleModel copyWith({
    String? id,
    String? userId,
    String? brand,
    String? model,
    int? year,
    String? color,
    String? licensePlate,
    String? vinNumber,
    VehicleType? vehicleType,
    FuelType? fuelType,
    double? initialOdometer,
    double? currentOdometer,
    double? tankCapacity,
    double? averageConsumption,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    String? notes,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
      vinNumber: vinNumber ?? this.vinNumber,
      vehicleType: vehicleType ?? this.vehicleType,
      fuelType: fuelType ?? this.fuelType,
      initialOdometer: initialOdometer ?? this.initialOdometer,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      tankCapacity: tankCapacity ?? this.tankCapacity,
      averageConsumption: averageConsumption ?? this.averageConsumption,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
    );
  }

  /// Nombre completo del vehículo (Marca Modelo Año)
  String get fullName => '$brand $model ($year)';

  /// Kilómetros recorridos desde el registro
  double get totalKilometers => currentOdometer - initialOdometer;

  /// Verifica si es un vehículo eléctrico
  bool get isElectric => fuelType == FuelType.electric || fuelType == FuelType.hybrid;

  @override
  List<Object?> get props => [
        id,
        userId,
        brand,
        model,
        year,
        color,
        licensePlate,
        vinNumber,
        vehicleType,
        fuelType,
        initialOdometer,
        currentOdometer,
        tankCapacity,
        averageConsumption,
        imageUrl,
        createdAt,
        updatedAt,
        isActive,
        notes,
      ];
}

/// Tipos de vehículos
enum VehicleType {
  @JsonValue('car')
  car,
  @JsonValue('motorcycle')
  motorcycle,
  @JsonValue('truck')
  truck,
  @JsonValue('van')
  van,
  @JsonValue('suv')
  suv,
  @JsonValue('other')
  other,
}

/// Tipos de combustible/energía
enum FuelType {
  @JsonValue('gasoline')
  gasoline,
  @JsonValue('diesel')
  diesel,
  @JsonValue('electric')
  electric,
  @JsonValue('hybrid')
  hybrid,
  @JsonValue('lpg')
  lpg,
  @JsonValue('cng')
  cng,
  @JsonValue('other')
  other,
}
