# 🚀 Guía de Despliegue - AutoMate

## 📋 Configuración Requerida para Play Store y App Store

### 🔧 Configuraciones que DEBES cambiar antes del lanzamiento:

#### 1. **Firebase - Configuración de Producción**
- [ ] **Crear proyecto de Firebase de producción** (separado del de desarrollo)
- [ ] **Descargar nuevos archivos de configuración:**
  - `android/app/google-services.json` (Android)
  - `ios/Runner/GoogleService-Info.plist` (iOS)
- [ ] **Configurar Firestore Database** con reglas de producción
- [ ] **Configurar Firebase Authentication** con dominios autorizados
- [ ] **Configurar Firebase Storage** con reglas de seguridad

#### 2. **AdMob - IDs de Producción**
Actualizar en `android/app/src/main/AndroidManifest.xml`:
```xml
<!-- CAMBIAR: ID de prueba por ID real de AdMob -->
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
```

Actualizar IDs en el código:
- `lib/core/services/ads_service.dart`
- Cambiar IDs de prueba por IDs reales de tus unidades publicitarias

#### 3. **Signing - Certificados de Producción**

**Android:**
```bash
# Generar keystore de producción
keytool -genkey -v -keystore ~/automate-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias automate-key

# Crear android/key.properties
storePassword=TU_STORE_PASSWORD
keyPassword=TU_KEY_PASSWORD  
keyAlias=automate-key
storeFile=/ruta/completa/a/automate-release-key.keystore
```

**iOS:**
- Crear certificados de distribución en Apple Developer
- Configurar provisioning profiles
- Actualizar `ios/Runner.xcodeproj/project.pbxproj`

#### 4. **Package Name/Bundle ID**
- **Android**: `com.stolzofficial.automate` (ya configurado)
- **iOS**: Configurar en Xcode el Bundle Identifier

#### 5. **Versioning**
Actualizar en `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Cambiar según tu estrategia de versiones
```

#### 6. **SHA-1 Fingerprints**
Obtener SHA-1 del keystore de producción:
```bash
keytool -list -v -keystore ~/automate-release-key.keystore -alias automate-key
```
Agregar en Firebase Console > Project Settings > SHA certificate fingerprints

#### 7. **In-App Purchases - IDs de Producción**
Actualizar en `lib/core/services/subscription_service.dart`:
```dart
// CAMBIAR: IDs de prueba por IDs reales
static const String monthlySubscriptionId = 'automate_premium_monthly';
static const String yearlySubscriptionId = 'automate_premium_yearly';  
static const String lifetimeSubscriptionId = 'automate_premium_lifetime';
```

#### 8. **URLs y Dominios**
- [ ] **Términos y Condiciones**: URL real en producción
- [ ] **Política de Privacidad**: URL real en producción
- [ ] **Soporte**: Email real de soporte

#### 9. **Base de Datos - Migrar de Prueba a Producción**
- [ ] **Firestore**: Usar proyecto de producción
- [ ] **Eliminar datos de prueba** del código
- [ ] **Configurar índices** en Firestore Console
- [ ] **Configurar reglas de seguridad** apropiadas

#### 10. **Iconos y Assets**
- [ ] **App Icon**: Verificar que sea el definitivo
- [ ] **Splash Screen**: Configurar para producción
- [ ] **Screenshots**: Preparar para stores

---

## 🛠️ Comandos de Build

### Android (Play Store)
```bash
# Build APK de release
flutter build apk --release

# Build App Bundle (recomendado para Play Store)
flutter build appbundle --release
```

### iOS (App Store)
```bash
# Build para iOS
flutter build ios --release

# Abrir en Xcode para subir a App Store Connect
open ios/Runner.xcworkspace
```

---

## 📱 Configuración de Stores

### Google Play Store
1. **Crear cuenta de desarrollador** ($25 USD una vez)
2. **Subir App Bundle** (.aab file)
3. **Configurar listing de la app**:
   - Título: "AutoMate - Gestor de Vehículos"
   - Descripción corta y larga
   - Screenshots (mínimo 2, máximo 8)
   - Icono de alta resolución (512x512)
4. **Configurar precios** de suscripciones
5. **Política de privacidad** (URL requerida)
6. **Clasificación de contenido**

### Apple App Store
1. **Cuenta de desarrollador** ($99 USD/año)
2. **App Store Connect**:
   - Crear nueva app
   - Configurar metadata
   - Subir build desde Xcode
3. **Configurar In-App Purchases**
4. **Review Guidelines** - asegurar cumplimiento

---

## 🔒 Seguridad y Compliance

### Datos Requeridos
- [ ] **Política de Privacidad** (obligatoria)
- [ ] **Términos de Servicio** (recomendado)
- [ ] **Declaración de datos** (Play Store)
- [ ] **App Privacy** (App Store)

### Permisos
Verificar que solo se soliciten permisos necesarios:
- `INTERNET` - Para conectividad
- `CAMERA` - Para fotos de vehículos
- `READ/WRITE_EXTERNAL_STORAGE` - Para exportar CSV

---

## 🧪 Testing Pre-Launch

### Checklist de Pruebas
- [ ] **Registro/Login** funciona correctamente
- [ ] **Suscripciones** se procesan correctamente
- [ ] **Anuncios** se muestran apropiadamente
- [ ] **Exportar datos** funciona
- [ ] **Navegación** entre pantallas
- [ ] **Validación** de formularios
- [ ] **Manejo de errores** de red
- [ ] **Performance** en dispositivos de gama baja

### Testing en Dispositivos Reales
- [ ] **Android**: Diferentes versiones (API 21+)
- [ ] **iOS**: Diferentes versiones (iOS 12+)
- [ ] **Tablets**: Verificar responsive design
- [ ] **Orientaciones**: Portrait y landscape

---

## 📊 Analytics y Monitoring

### Configurar
- [ ] **Firebase Analytics** para métricas de uso
- [ ] **Firebase Crashlytics** para reportes de crashes
- [ ] **AdMob** para métricas de anuncios
- [ ] **Play Console/App Store Connect** para métricas de stores

---

## 🚨 Checklist Final Pre-Launch

### Código
- [ ] Remover todos los `print()` y `debugPrint()`
- [ ] Remover datos de prueba hardcodeados
- [ ] Verificar que no hay TODOs críticos
- [ ] Optimizar imports (remover unused)
- [ ] Ejecutar `flutter analyze` sin errores

### Configuración
- [ ] Firebase de producción configurado
- [ ] AdMob IDs de producción
- [ ] Keystore de producción creado
- [ ] SHA-1 agregado a Firebase
- [ ] In-App Purchase IDs configurados
- [ ] URLs de términos/privacidad actualizadas

### Assets
- [ ] Iconos finales
- [ ] Splash screen
- [ ] Screenshots para stores
- [ ] Descripción de la app
- [ ] Metadata completo

### Testing
- [ ] Pruebas en dispositivos reales
- [ ] Flujo completo de suscripción
- [ ] Anuncios funcionando
- [ ] Exportación de datos
- [ ] Performance aceptable

---

## 📞 Soporte Post-Launch

### Preparar
- [ ] **Email de soporte**: support@automate.app
- [ ] **Documentación de usuario**
- [ ] **FAQ** actualizado
- [ ] **Plan de actualizaciones**
- [ ] **Monitoreo de reviews**

---

## 🎯 Notas Importantes

1. **Nunca uses IDs de prueba en producción**
2. **Siempre prueba suscripciones en sandbox primero**
3. **Mantén backups de tus keystores**
4. **Documenta todos los cambios de configuración**
5. **Prueba en dispositivos reales antes del lanzamiento**

---

**¡La app está lista para producción una vez completados todos estos pasos!** 🎉
