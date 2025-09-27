import 'package:cloud_firestore/cloud_firestore.dart';

enum MaintenanceType {
  oilChange,
  tireRotation,
  brakeService,
  inspection,
  other,
}

class MaintenanceModel {
  final String id;
  final String userId;
  final String vehicleId;
  final String vehicleName;
  final String title;
  final String? description;
  final MaintenanceType type;
  final DateTime dueDate;
  final DateTime? completedDate;
  final double? cost;
  final int? odometer;
  final String? notes;
  final String? receiptUrl;
  final bool isRecurring;
  final int? recurringInterval; // in months
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.vehicleName,
    required this.title,
    this.description,
    required this.type,
    required this.dueDate,
    this.completedDate,
    this.cost,
    this.odometer,
    this.notes,
    this.receiptUrl,
    this.isRecurring = false,
    this.recurringInterval,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Firestore Document to MaintenanceModel
  factory MaintenanceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MaintenanceModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      vehicleName: data['vehicleName'] ?? 'Vehículo desconocido',
      title: data['title'] ?? 'Mantenimiento sin título',
      description: data['description'],
      type: _maintenanceTypeFromString(data['type'] ?? 'other'),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      completedDate: data['completedDate'] != null 
          ? (data['completedDate'] as Timestamp).toDate() 
          : null,
      cost: (data['cost'] as num?)?.toDouble(),
      odometer: data['odometer'] as int?,
      notes: data['notes'],
      receiptUrl: data['receiptUrl'],
      isRecurring: data['isRecurring'] ?? false,
      recurringInterval: data['recurringInterval'] as int?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Convert MaintenanceModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'dueDate': Timestamp.fromDate(dueDate),
      'completedDate': completedDate != null 
          ? Timestamp.fromDate(completedDate!)
          : null,
      'cost': cost,
      'odometer': odometer,
      'notes': notes,
      'receiptUrl': receiptUrl,
      'isRecurring': isRecurring,
      'recurringInterval': recurringInterval,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper to convert string to MaintenanceType
  static MaintenanceType _maintenanceTypeFromString(String type) {
    return MaintenanceType.values.firstWhere(
      (e) => e.toString() == 'MaintenanceType.${type.toLowerCase()}',
      orElse: () => MaintenanceType.other,
    );
  }

  // Create a copy with some fields updated
  MaintenanceModel copyWith({
    String? id,
    String? userId,
    String? vehicleId,
    String? vehicleName,
    String? title,
    String? description,
    MaintenanceType? type,
    DateTime? dueDate,
    DateTime? completedDate,
    double? cost,
    int? odometer,
    String? notes,
    String? receiptUrl,
    bool? isRecurring,
    int? recurringInterval,
  }) {
    return MaintenanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleName: vehicleName ?? this.vehicleName,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      completedDate: completedDate ?? this.completedDate,
      cost: cost ?? this.cost,
      odometer: odometer ?? this.odometer,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringInterval: recurringInterval ?? this.recurringInterval,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
