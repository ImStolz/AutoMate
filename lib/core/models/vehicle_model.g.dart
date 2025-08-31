// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      color: json['color'] as String,
      licensePlate: json['licensePlate'] as String?,
      vinNumber: json['vinNumber'] as String?,
      vehicleType: $enumDecode(_$VehicleTypeEnumMap, json['vehicleType']),
      fuelType: $enumDecode(_$FuelTypeEnumMap, json['fuelType']),
      initialOdometer: (json['initialOdometer'] as num).toDouble(),
      currentOdometer: (json['currentOdometer'] as num).toDouble(),
      tankCapacity: (json['tankCapacity'] as num?)?.toDouble(),
      averageConsumption: (json['averageConsumption'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'brand': instance.brand,
      'model': instance.model,
      'year': instance.year,
      'color': instance.color,
      'licensePlate': instance.licensePlate,
      'vinNumber': instance.vinNumber,
      'vehicleType': _$VehicleTypeEnumMap[instance.vehicleType]!,
      'fuelType': _$FuelTypeEnumMap[instance.fuelType]!,
      'initialOdometer': instance.initialOdometer,
      'currentOdometer': instance.currentOdometer,
      'tankCapacity': instance.tankCapacity,
      'averageConsumption': instance.averageConsumption,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isActive': instance.isActive,
      'notes': instance.notes,
    };

const _$VehicleTypeEnumMap = {
  VehicleType.car: 'car',
  VehicleType.motorcycle: 'motorcycle',
  VehicleType.truck: 'truck',
  VehicleType.van: 'van',
  VehicleType.suv: 'suv',
  VehicleType.other: 'other',
};

const _$FuelTypeEnumMap = {
  FuelType.gasoline: 'gasoline',
  FuelType.diesel: 'diesel',
  FuelType.electric: 'electric',
  FuelType.hybrid: 'hybrid',
  FuelType.lpg: 'lpg',
  FuelType.cng: 'cng',
  FuelType.other: 'other',
};
