import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/auth_provider.dart';

/// Punto de entrada principal de la aplicación AutoMate
void main() async {
  // Asegurar que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase con manejo de errores
  try {
    await FirebaseService.initialize();
  } catch (e) {
    print('Firebase initialization error (continuing without Firebase): $e');
  }
  
  // Ejecutar la aplicación con Riverpod
  runApp(
    const ProviderScope(
      child: AutoMateApp(),
    ),
  );
}

/// Widget principal de la aplicación AutoMate
class AutoMateApp extends ConsumerWidget {
  const AutoMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authNotifierProvider);
    
    return MaterialApp.router(
      // Configuración básica
      title: 'AutoMate',
      debugShowCheckedModeBanner: false,
      
      // Configuración de temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _getThemeMode(authState.userModel?.settings.isDarkMode),
      
      // Configuración de router
      routerConfig: router,
      
      // Configuración de localización
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español España
        Locale('es', 'CL'), // Español Chile
        Locale('en', 'US'), // Inglés (fallback)
      ],
      locale: _getLocale(authState.userModel?.settings.language),
      
      // Builder para manejar errores globales
      builder: (context, child) {
        // Configurar el manejo de errores de UI
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return _buildErrorWidget(context, errorDetails);
        };
        
        return child ?? const SizedBox.shrink();
      },
    );
  }

  /// Determina el modo de tema basado en la configuración del usuario
  ThemeMode _getThemeMode(bool? isDarkMode) {
    if (isDarkMode == null) return ThemeMode.system;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// Determina el locale basado en la configuración del usuario
  Locale _getLocale(String? language) {
    switch (language) {
      case 'es-ES':
        return const Locale('es', 'ES');
      case 'es-CL':
        return const Locale('es', 'CL');
      case 'en':
        return const Locale('en', 'US');
      default:
        return const Locale('es', 'ES'); // Español España por defecto
    }
  }

  /// Construye un widget de error personalizado
  Widget _buildErrorWidget(BuildContext context, FlutterErrorDetails errorDetails) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Algo salió mal',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Ha ocurrido un error inesperado. Por favor, reinicia la aplicación.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implementar reinicio de la aplicación
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
