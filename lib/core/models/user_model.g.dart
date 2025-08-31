// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      subscriptionType: $enumDecodeNullable(
              _$SubscriptionTypeEnumMap, json['subscriptionType']) ??
          SubscriptionType.free,
      subscriptionExpiresAt: json['subscriptionExpiresAt'] == null
          ? null
          : DateTime.parse(json['subscriptionExpiresAt'] as String),
      settings: json['settings'] == null
          ? const UserSettings()
          : UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'subscriptionType': _$SubscriptionTypeEnumMap[instance.subscriptionType]!,
      'subscriptionExpiresAt':
          instance.subscriptionExpiresAt?.toIso8601String(),
      'settings': instance.settings,
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.free: 'free',
  SubscriptionType.premiumMonthly: 'premium_monthly',
  SubscriptionType.premiumYearly: 'premium_yearly',
  SubscriptionType.lifetime: 'lifetime',
};

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      language: json['language'] as String? ?? 'es',
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      distanceUnit:
          $enumDecodeNullable(_$DistanceUnitEnumMap, json['distanceUnit']) ??
              DistanceUnit.kilometers,
      volumeUnit:
          $enumDecodeNullable(_$VolumeUnitEnumMap, json['volumeUnit']) ??
              VolumeUnit.liters,
      currency: json['currency'] as String? ?? 'EUR',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      maintenanceReminders: json['maintenanceReminders'] as bool? ?? true,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'language': instance.language,
      'isDarkMode': instance.isDarkMode,
      'distanceUnit': _$DistanceUnitEnumMap[instance.distanceUnit]!,
      'volumeUnit': _$VolumeUnitEnumMap[instance.volumeUnit]!,
      'currency': instance.currency,
      'notificationsEnabled': instance.notificationsEnabled,
      'maintenanceReminders': instance.maintenanceReminders,
    };

const _$DistanceUnitEnumMap = {
  DistanceUnit.kilometers: 'km',
  DistanceUnit.miles: 'miles',
};

const _$VolumeUnitEnumMap = {
  VolumeUnit.liters: 'liters',
  VolumeUnit.gallons: 'gallons',
};
