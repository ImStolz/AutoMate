import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

/// Notificador para la gestión de idioma global
class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('es', 'ES')) {
    _loadSavedLanguage();
  }

  /// Carga el idioma guardado desde SharedPreferences
  Future<void> _loadSavedLanguage() async {
    try {
      final savedLanguage = PreferencesService.getLanguage();
      state = _getLocaleFromString(savedLanguage);
    } catch (e) {
      // Si hay error, mantener español por defecto
      print('Error loading saved language: $e');
    }
  }

  /// Cambia el idioma seleccionado
  Future<void> setLanguage(String languageCode) async {
    try {
      await PreferencesService.setLanguage(languageCode);
      state = _getLocaleFromString(languageCode);
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  /// Convierte string de idioma a Locale
  Locale _getLocaleFromString(String language) {
    switch (language) {
      case 'en':
        return const Locale('en', 'US');
      case 'es':
      default:
        return const Locale('es', 'ES');
    }
  }

  /// Obtiene el código del idioma actual
  String get languageCode => state.languageCode;

  /// Obtiene el nombre del idioma actual
  String get languageName {
    switch (state.languageCode) {
      case 'en':
        return 'English';
      case 'es':
      default:
        return 'Español';
    }
  }
}

/// Provider para el idioma global
final languageNotifierProvider = StateNotifierProvider<LanguageNotifier, Locale>(
  (ref) => LanguageNotifier(),
);
