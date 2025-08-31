// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseModel _$ExpenseModelFromJson(Map<String, dynamic> json) => ExpenseModel(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      userId: json['userId'] as String,
      category: $enumDecode(_$ExpenseCategoryEnumMap, json['category']),
      subcategory: json['subcategory'] as String?,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      date: DateTime.parse(json['date'] as String),
      odometer: (json['odometer'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toDouble(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      receiptImageUrl: json['receiptImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$ExpenseModelToJson(ExpenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleId': instance.vehicleId,
      'userId': instance.userId,
      'category': _$ExpenseCategoryEnumMap[instance.category]!,
      'subcategory': instance.subcategory,
      'description': instance.description,
      'amount': instance.amount,
      'currency': instance.currency,
      'date': instance.date.toIso8601String(),
      'odometer': instance.odometer,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'location': instance.location,
      'notes': instance.notes,
      'receiptImageUrl': instance.receiptImageUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'tags': instance.tags,
    };

const _$ExpenseCategoryEnumMap = {
  ExpenseCategory.fuel: 'fuel',
  ExpenseCategory.maintenance: 'maintenance',
  ExpenseCategory.repairs: 'repairs',
  ExpenseCategory.insurance: 'insurance',
  ExpenseCategory.registration: 'registration',
  ExpenseCategory.parking: 'parking',
  ExpenseCategory.tolls: 'tolls',
  ExpenseCategory.accessories: 'accessories',
  ExpenseCategory.cleaning: 'cleaning',
  ExpenseCategory.other: 'other',
};
