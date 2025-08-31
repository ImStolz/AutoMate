import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense_model.g.dart';

/// Modelo de datos para gastos del vehículo
/// Incluye combustible, repuestos, seguros, accesorios, etc.
@JsonSerializable()
class ExpenseModel extends Equatable {
  /// ID único del gasto
  final String id;
  
  /// ID del vehículo asociado
  final String vehicleId;
  
  /// ID del usuario propietario
  final String userId;
  
  /// Categoría del gasto
  final ExpenseCategory category;
  
  /// Subcategoría específica (opcional)
  final String? subcategory;
  
  /// Descripción del gasto
  final String description;
  
  /// Monto del gasto
  final double amount;
  
  /// Moneda del gasto
  final String currency;
  
  /// Fecha del gasto
  final DateTime date;
  
  /// Odómetro al momento del gasto (en km)
  final double? odometer;
  
  /// Cantidad de combustible/energía (litros, kWh)
  final double? quantity;
  
  /// Precio por unidad (precio por litro, kWh, etc.)
  final double? unitPrice;
  
  /// Lugar donde se realizó el gasto
  final String? location;
  
  /// Notas adicionales
  final String? notes;
  
  /// URL de la imagen del recibo/factura
  final String? receiptImageUrl;
  
  /// Fecha de creación del registro
  final DateTime createdAt;
  
  /// Última actualización
  final DateTime updatedAt;
  
  /// Etiquetas personalizadas
  final List<String> tags;

  const ExpenseModel({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.category,
    this.subcategory,
    required this.description,
    required this.amount,
    required this.currency,
    required this.date,
    this.odometer,
    this.quantity,
    this.unitPrice,
    this.location,
    this.notes,
    this.receiptImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => 
      _$ExpenseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  ExpenseModel copyWith({
    String? id,
    String? vehicleId,
    String? userId,
    ExpenseCategory? category,
    String? subcategory,
    String? description,
    double? amount,
    String? currency,
    DateTime? date,
    double? odometer,
    double? quantity,
    double? unitPrice,
    String? location,
    String? notes,
    String? receiptImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      odometer: odometer ?? this.odometer,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }

  /// Verifica si es un gasto de combustible
  bool get isFuelExpense => category == ExpenseCategory.fuel;

  /// Calcula el costo por kilómetro si hay datos de odómetro
  double? get costPerKilometer {
    if (odometer == null) return null;
    return amount / (odometer! / 100); // Costo por 100km
  }

  /// Calcula la eficiencia de combustible (km/L o km/kWh)
  double? get fuelEfficiency {
    if (quantity == null || quantity! <= 0) return null;
    if (odometer == null) return null;
    
    // Asumiendo que el odómetro representa la distancia recorrida con este tanque
    return odometer! / quantity!;
  }

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        userId,
        category,
        subcategory,
        description,
        amount,
        currency,
        date,
        odometer,
        quantity,
        unitPrice,
        location,
        notes,
        receiptImageUrl,
        createdAt,
        updatedAt,
        tags,
      ];
}

/// Categorías de gastos
enum ExpenseCategory {
  @JsonValue('fuel')
  fuel,
  @JsonValue('maintenance')
  maintenance,
  @JsonValue('repairs')
  repairs,
  @JsonValue('insurance')
  insurance,
  @JsonValue('registration')
  registration,
  @JsonValue('parking')
  parking,
  @JsonValue('tolls')
  tolls,
  @JsonValue('accessories')
  accessories,
  @JsonValue('cleaning')
  cleaning,
  @JsonValue('other')
  other,
}
