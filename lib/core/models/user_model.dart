import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// Modelo de datos para el usuario de la aplicación
/// Incluye información del perfil y configuración de suscripción
@JsonSerializable()
class UserModel extends Equatable {
  /// ID único del usuario (Firebase UID)
  final String id;
  
  /// Email del usuario
  final String email;
  
  /// Nombre completo del usuario
  final String displayName;
  
  /// URL de la foto de perfil
  final String? photoUrl;
  
  /// Fecha de creación de la cuenta
  final DateTime createdAt;
  
  /// Última fecha de actualización del perfil
  final DateTime updatedAt;
  
  /// Tipo de suscripción del usuario
  final SubscriptionType subscriptionType;
  
  /// Fecha de expiración de la suscripción premium (null si es gratuita)
  final DateTime? subscriptionExpiresAt;
  
  /// Configuraciones del usuario
  final UserSettings settings;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.subscriptionType = SubscriptionType.free,
    this.subscriptionExpiresAt,
    this.settings = const UserSettings(),
  });

  /// Factory constructor para crear desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Crea una copia del modelo con campos actualizados
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionExpiresAt,
    UserSettings? settings,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      settings: settings ?? this.settings,
    );
  }

  /// Verifica si el usuario tiene suscripción premium activa
  bool get isPremium {
    if (subscriptionType == SubscriptionType.free) return false;
    if (subscriptionType == SubscriptionType.lifetime) return true;
    
    return subscriptionExpiresAt != null && 
           subscriptionExpiresAt!.isAfter(DateTime.now());
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        createdAt,
        updatedAt,
        subscriptionType,
        subscriptionExpiresAt,
        settings,
      ];
}

/// Tipos de suscripción disponibles
enum SubscriptionType {
  @JsonValue('free')
  free,
  @JsonValue('premium_monthly')
  premiumMonthly,
  @JsonValue('premium_yearly')
  premiumYearly,
  @JsonValue('lifetime')
  lifetime,
}

/// Configuraciones del usuario
@JsonSerializable()
class UserSettings extends Equatable {
  /// Idioma preferido
  final String language;
  
  /// Modo oscuro activado
  final bool isDarkMode;
  
  /// Unidad de distancia (km/miles)
  final DistanceUnit distanceUnit;
  
  /// Unidad de volumen (litros/galones)
  final VolumeUnit volumeUnit;
  
  /// Moneda preferida
  final String currency;
  
  /// Notificaciones push activadas
  final bool notificationsEnabled;
  
  /// Recordatorios de mantenimiento activados
  final bool maintenanceReminders;

  const UserSettings({
    this.language = 'es',
    this.isDarkMode = false,
    this.distanceUnit = DistanceUnit.kilometers,
    this.volumeUnit = VolumeUnit.liters,
    this.currency = 'EUR',
    this.notificationsEnabled = true,
    this.maintenanceReminders = true,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => 
      _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  UserSettings copyWith({
    String? language,
    bool? isDarkMode,
    DistanceUnit? distanceUnit,
    VolumeUnit? volumeUnit,
    String? currency,
    bool? notificationsEnabled,
    bool? maintenanceReminders,
  }) {
    return UserSettings(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      volumeUnit: volumeUnit ?? this.volumeUnit,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      maintenanceReminders: maintenanceReminders ?? this.maintenanceReminders,
    );
  }

  @override
  List<Object?> get props => [
        language,
        isDarkMode,
        distanceUnit,
        volumeUnit,
        currency,
        notificationsEnabled,
        maintenanceReminders,
      ];
}

/// Unidades de distancia
enum DistanceUnit {
  @JsonValue('km')
  kilometers,
  @JsonValue('miles')
  miles,
}

/// Unidades de volumen
enum VolumeUnit {
  @JsonValue('liters')
  liters,
  @JsonValue('gallons')
  gallons,
}
