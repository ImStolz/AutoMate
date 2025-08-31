import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'maintenance_model.g.dart';

/// Modelo de datos para mantenimientos del vehículo
/// Incluye servicios realizados y recordatorios programados
@JsonSerializable()
class MaintenanceModel extends Equatable {
  /// ID único del mantenimiento
  final String id;
  
  /// ID del vehículo asociado
  final String vehicleId;
  
  /// ID del usuario propietario
  final String userId;
  
  /// Tipo de mantenimiento
  final MaintenanceType type;
  
  /// Título/nombre del mantenimiento
  final String title;
  
  /// Descripción detallada
  final String description;
  
  /// Estado del mantenimiento
  final MaintenanceStatus status;
  
  /// Fecha de realización (null si es recordatorio futuro)
  final DateTime? completedDate;
  
  /// Odómetro al momento del mantenimiento
  final double? completedOdometer;
  
  /// Costo del mantenimiento
  final double? cost;
  
  /// Moneda del costo
  final String? currency;
  
  /// Lugar donde se realizó (taller, mecánico, etc.)
  final String? serviceProvider;
  
  /// Próxima fecha recomendada para este mantenimiento
  final DateTime? nextDueDate;
  
  /// Próximo odómetro recomendado
  final double? nextDueOdometer;
  
  /// Intervalo en días para repetir
  final int? intervalDays;
  
  /// Intervalo en kilómetros para repetir
  final double? intervalKilometers;
  
  /// Notas adicionales
  final String? notes;
  
  /// URLs de imágenes (facturas, fotos del trabajo)
  final List<String> imageUrls;
  
  /// Fecha de creación del registro
  final DateTime createdAt;
  
  /// Última actualización
  final DateTime updatedAt;
  
  /// Recordatorio activado
  final bool reminderEnabled;
  
  /// Días de anticipación para el recordatorio
  final int reminderDaysBefore;

  const MaintenanceModel({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.status,
    this.completedDate,
    this.completedOdometer,
    this.cost,
    this.currency,
    this.serviceProvider,
    this.nextDueDate,
    this.nextDueOdometer,
    this.intervalDays,
    this.intervalKilometers,
    this.notes,
    this.imageUrls = const [],
    required this.createdAt,
    required this.updatedAt,
    this.reminderEnabled = true,
    this.reminderDaysBefore = 7,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) => 
      _$MaintenanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintenanceModelToJson(this);

  MaintenanceModel copyWith({
    String? id,
    String? vehicleId,
    String? userId,
    MaintenanceType? type,
    String? title,
    String? description,
    MaintenanceStatus? status,
    DateTime? completedDate,
    double? completedOdometer,
    double? cost,
    String? currency,
    String? serviceProvider,
    DateTime? nextDueDate,
    double? nextDueOdometer,
    int? intervalDays,
    double? intervalKilometers,
    String? notes,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? reminderEnabled,
    int? reminderDaysBefore,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      completedDate: completedDate ?? this.completedDate,
      completedOdometer: completedOdometer ?? this.completedOdometer,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      serviceProvider: serviceProvider ?? this.serviceProvider,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      nextDueOdometer: nextDueOdometer ?? this.nextDueOdometer,
      intervalDays: intervalDays ?? this.intervalDays,
      intervalKilometers: intervalKilometers ?? this.intervalKilometers,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    );
  }

  /// Verifica si el mantenimiento está vencido por fecha
  bool get isOverdueByDate {
    if (nextDueDate == null || status == MaintenanceStatus.completed) return false;
    return DateTime.now().isAfter(nextDueDate!);
  }

  /// Verifica si el mantenimiento está vencido por kilometraje
  bool isOverdueByOdometer(double currentOdometer) {
    if (nextDueOdometer == null || status == MaintenanceStatus.completed) return false;
    return currentOdometer >= nextDueOdometer!;
  }

  /// Calcula los días restantes hasta el próximo mantenimiento
  int? get daysUntilDue {
    if (nextDueDate == null) return null;
    return nextDueDate!.difference(DateTime.now()).inDays;
  }

  /// Calcula los kilómetros restantes hasta el próximo mantenimiento
  double? kilometersUntilDue(double currentOdometer) {
    if (nextDueOdometer == null) return null;
    return nextDueOdometer! - currentOdometer;
  }

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        userId,
        type,
        title,
        description,
        status,
        completedDate,
        completedOdometer,
        cost,
        currency,
        serviceProvider,
        nextDueDate,
        nextDueOdometer,
        intervalDays,
        intervalKilometers,
        notes,
        imageUrls,
        createdAt,
        updatedAt,
        reminderEnabled,
        reminderDaysBefore,
      ];
}

/// Tipos de mantenimiento
enum MaintenanceType {
  @JsonValue('oil_change')
  oilChange,
  @JsonValue('tire_rotation')
  tireRotation,
  @JsonValue('brake_service')
  brakeService,
  @JsonValue('battery_replacement')
  batteryReplacement,
  @JsonValue('air_filter')
  airFilter,
  @JsonValue('fuel_filter')
  fuelFilter,
  @JsonValue('spark_plugs')
  sparkPlugs,
  @JsonValue('transmission_service')
  transmissionService,
  @JsonValue('coolant_flush')
  coolantFlush,
  @JsonValue('inspection')
  inspection,
  @JsonValue('registration_renewal')
  registrationRenewal,
  @JsonValue('insurance_renewal')
  insuranceRenewal,
  @JsonValue('general_service')
  generalService,
  @JsonValue('custom')
  custom,
}

/// Estados del mantenimiento
enum MaintenanceStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('due_soon')
  dueSoon,
  @JsonValue('overdue')
  overdue,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}
