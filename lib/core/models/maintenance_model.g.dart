// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaintenanceModel _$MaintenanceModelFromJson(Map<String, dynamic> json) =>
    MaintenanceModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$MaintenanceTypeEnumMap, json['type']),
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$MaintenanceStatusEnumMap, json['status']),
      completedDate: json['completedDate'] == null
          ? null
          : DateTime.parse(json['completedDate'] as String),
      completedOdometer: (json['completedOdometer'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      serviceProvider: json['serviceProvider'] as String?,
      nextDueDate: json['nextDueDate'] == null
          ? null
          : DateTime.parse(json['nextDueDate'] as String),
      nextDueOdometer: (json['nextDueOdometer'] as num?)?.toDouble(),
      intervalDays: (json['intervalDays'] as num?)?.toInt(),
      intervalKilometers: (json['intervalKilometers'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      reminderDaysBefore: (json['reminderDaysBefore'] as num?)?.toInt() ?? 7,
    );

Map<String, dynamic> _$MaintenanceModelToJson(MaintenanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'userId': instance.userId,
      'type': _$MaintenanceTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'status': _$MaintenanceStatusEnumMap[instance.status]!,
      'completedDate': instance.completedDate?.toIso8601String(),
      'completedOdometer': instance.completedOdometer,
      'cost': instance.cost,
      'currency': instance.currency,
      'serviceProvider': instance.serviceProvider,
      'nextDueDate': instance.nextDueDate?.toIso8601String(),
      'nextDueOdometer': instance.nextDueOdometer,
      'intervalDays': instance.intervalDays,
      'intervalKilometers': instance.intervalKilometers,
      'notes': instance.notes,
      'imageUrls': instance.imageUrls,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'reminderEnabled': instance.reminderEnabled,
      'reminderDaysBefore': instance.reminderDaysBefore,
    };

const _$MaintenanceTypeEnumMap = {
  MaintenanceType.oilChange: 'oil_change',
  MaintenanceType.tireRotation: 'tire_rotation',
  MaintenanceType.brakeService: 'brake_service',
  MaintenanceType.batteryReplacement: 'battery_replacement',
  MaintenanceType.airFilter: 'air_filter',
  MaintenanceType.fuelFilter: 'fuel_filter',
  MaintenanceType.sparkPlugs: 'spark_plugs',
  MaintenanceType.transmissionService: 'transmission_service',
  MaintenanceType.coolantFlush: 'coolant_flush',
  MaintenanceType.inspection: 'inspection',
  MaintenanceType.registrationRenewal: 'registration_renewal',
  MaintenanceType.insuranceRenewal: 'insurance_renewal',
  MaintenanceType.generalService: 'general_service',
  MaintenanceType.custom: 'custom',
};

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.pending: 'pending',
  MaintenanceStatus.dueSoon: 'due_soon',
  MaintenanceStatus.overdue: 'overdue',
  MaintenanceStatus.inProgress: 'in_progress',
  MaintenanceStatus.completed: 'completed',
  MaintenanceStatus.cancelled: 'cancelled',
};
