# AutoMate - Gestor de Gastos y Mantenimiento de Vehículos

AutoMate es una aplicación móvil completa para gestionar gastos y mantenimiento de vehículos, desarrollada con Flutter y Firebase.

## 🎯 Características Principales

### ✨ Funcionalidades Core
- **Gestión de Vehículos**: Registra hasta 2 vehículos gratis (ilimitados en Premium)
- **Seguimiento de Gastos**: Combustible, repuestos, seguros, accesorios
- **Mantenimientos**: Recordatorios por kilometraje y tiempo
- **Dashboard Inteligente**: Gráficos y estadísticas de consumo
- **Sincronización en la Nube**: Datos seguros con Firebase
- **Modo Offline**: Funciona sin conexión con SQLite local

### 🎨 Diseño y UX
- **Interfaz Moderna**: Diseño minimalista con Material Design 3
- **Modo Oscuro**: Tema claro/oscuro con acentos morados pastel
- **Responsive**: Optimizado para diferentes tamaños de pantalla
- **Accesibilidad**: Cumple con estándares de accesibilidad

### 🔐 Autenticación
- **Firebase Auth**: Login con email/contraseña y Google
- **Gestión de Usuarios**: Perfiles completos y configuraciones
- **Seguridad**: Autenticación robusta y datos encriptados

### 💰 Modelo Freemium
- **Plan Gratuito**: 2 vehículos, datos locales, anuncios
- **Plan Premium**: Vehículos ilimitados, exportación, sincronización, gráficos avanzados

## 🏗️ Arquitectura Técnica

### 📱 Frontend
- **Flutter 3.1+**: Framework multiplataforma
- **Riverpod**: Gestión de estado reactiva y escalable
- **Go Router**: Navegación declarativa
- **Material Design 3**: Sistema de diseño moderno

### ☁️ Backend
- **Firebase Authentication**: Gestión de usuarios
- **Cloud Firestore**: Base de datos NoSQL en tiempo real
- **Firebase Storage**: Almacenamiento de imágenes
- **SQLite**: Almacenamiento local offline

### 🎨 UI/UX
- **Tema Personalizado**: Colores morados pastel profesionales
- **Tipografía**: Fuente Poppins para mejor legibilidad
- **Componentes**: Widgets reutilizables y modulares
- **Animaciones**: Transiciones fluidas y micro-interacciones

## 📁 Estructura del Proyecto

```
lib/
├── core/                          # Núcleo de la aplicación
│   ├── models/                    # Modelos de datos
│   │   ├── user_model.dart
│   │   ├── vehicle_model.dart
│   │   ├── expense_model.dart
│   │   └── maintenance_model.dart
│   ├── providers/                 # Providers de Riverpod
│   │   └── auth_provider.dart
│   ├── services/                  # Servicios (Firebase, APIs)
│   │   └── firebase_service.dart
│   ├── theme/                     # Configuración de temas
│   │   └── app_theme.dart
│   └── router/                    # Configuración de navegación
│       └── app_router.dart
├── features/                      # Funcionalidades por módulos
│   ├── auth/                      # Autenticación
│   │   ├── screens/
│   │   └── widgets/
│   ├── dashboard/                 # Dashboard principal
│   │   ├── screens/
│   │   └── widgets/
│   ├── vehicles/                  # Gestión de vehículos
│   │   ├── screens/
│   │   └── widgets/
│   ├── expenses/                  # Gestión de gastos
│   │   ├── screens/
│   │   └── widgets/
│   ├── maintenance/               # Gestión de mantenimientos
│   │   ├── screens/
│   │   └── widgets/
│   └── profile/                   # Perfil y configuración
│       ├── screens/
│       └── widgets/
└── main.dart                      # Punto de entrada
```

## 🚀 Configuración del Proyecto

### Prerrequisitos
- **Flutter SDK**: 3.1.0 o superior
- **Dart SDK**: 3.1.0 o superior
- **Android Studio** o **VS Code** con extensiones de Flutter
- **Firebase CLI** para configuración de Firebase
- **Cuenta de Firebase** con proyecto configurado

### 🔧 Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone <repository-url>
   cd AutoMate
   ```

2. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**:
   ```bash
   # Instalar Firebase CLI
   npm install -g firebase-tools
   
   # Login en Firebase
   firebase login
   
   # Configurar FlutterFire
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

4. **Generar código**:
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

### 📱 Configuración por Plataforma

#### Android
1. Agregar `google-services.json` en `android/app/`
2. Configurar `android/app/build.gradle`
3. Configurar permisos en `android/app/src/main/AndroidManifest.xml`

#### iOS
1. Agregar `GoogleService-Info.plist` en `ios/Runner/`
2. Configurar `ios/Runner/Info.plist`
3. Configurar esquemas de URL para Google Sign-In

## 🔥 Configuración de Firebase

### Servicios Requeridos
- **Authentication**: Email/Password, Google Sign-In
- **Firestore Database**: Base de datos principal
- **Storage**: Almacenamiento de imágenes
- **Analytics**: Métricas de uso (opcional)

### Reglas de Firestore
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios pueden leer/escribir solo sus datos
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Vehículos del usuario autenticado
    match /vehicles/{vehicleId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Gastos del usuario autenticado
    match /expenses/{expenseId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Mantenimientos del usuario autenticado
    match /maintenance/{maintenanceId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

## 📊 Modelos de Datos

### Usuario
```dart
class UserModel {
  final String id;
  final String email;
  final String displayName;
  final SubscriptionType subscriptionType;
  final UserSettings settings;
  // ... más campos
}
```

### Vehículo
```dart
class VehicleModel {
  final String id;
  final String userId;
  final String brand;
  final String model;
  final int year;
  final VehicleType vehicleType;
  final FuelType fuelType;
  // ... más campos
}
```

### Gasto
```dart
class ExpenseModel {
  final String id;
  final String vehicleId;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
  // ... más campos
}
```

## 🧪 Testing

### Ejecutar Tests
```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration_test/

# Análisis de código
flutter analyze
```

### Estructura de Tests
```
test/
├── unit/                    # Tests unitarios
│   ├── models/
│   ├── services/
│   └── providers/
├── widget/                  # Tests de widgets
└── integration/             # Tests de integración
```

## 🚀 Despliegue

### Android
```bash
# Generar APK de release
flutter build apk --release

# Generar App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Generar IPA
flutter build ipa --release
```

## 🌐 Internacionalización

La app soporta múltiples idiomas:
- **Español (España)**: es-ES
- **Español (Chile)**: es-CL
- **Inglés**: en-US (fallback)

### Agregar Nuevos Idiomas
1. Crear archivos ARB en `lib/l10n/`
2. Ejecutar `flutter gen-l10n`
3. Actualizar `supportedLocales` en `main.dart`

## 🔮 Roadmap Futuro

### Versión 1.1
- [ ] Exportación a CSV/PDF/Excel (Premium)
- [ ] Mapas con gasolineras cercanas
- [ ] Precios de combustible en tiempo real

### Versión 1.2
- [ ] Vehículos eléctricos (kWh, cargas)
- [ ] Web App complementaria
- [ ] Integración OBD-II

### Versión 2.0
- [ ] IA para predicción de mantenimientos
- [ ] Comunidad de usuarios
- [ ] Marketplace de repuestos

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

### Estándares de Código
- Seguir las convenciones de Dart/Flutter
- Documentar funciones públicas
- Escribir tests para nuevas funcionalidades
- Usar `flutter analyze` antes de commit

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

## 👥 Equipo

- **Desarrollador Principal**: [Tu Nombre]
- **Diseño UI/UX**: [Diseñador]
- **Backend**: Firebase

## 📞 Soporte

- **Email**: support@automate-app.com
- **Documentación**: [Wiki del proyecto]
- **Issues**: [GitHub Issues]

## 🙏 Agradecimientos

- **Flutter Team** por el increíble framework
- **Firebase** por los servicios backend
- **Comunidad Flutter** por las librerías y recursos
- **Material Design** por las guías de diseño

---

**AutoMate** - Gestiona tus vehículos de manera inteligente 🚗✨
