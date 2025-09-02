import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para manejar las preferencias locales de la aplicación
class PreferencesService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _firstLaunchKey = 'first_launch';
  static const String _tutorialCompletedKey = 'tutorial_completed';
  static const String _premiumStatusKey = 'premium_status';
  static const String _lastAdShownKey = 'last_ad_shown';
  static const String _adCountKey = 'ad_count';
  static const String _selectedVehicleKey = 'selected_vehicle';
  static const String _selectedCurrencyKey = 'selected_currency';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _analyticsEnabledKey = 'analytics_enabled';

  static SharedPreferences? _prefs;

  /// Inicializar el servicio de preferencias
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Obtener instancia de SharedPreferences
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('PreferencesService no ha sido inicializado. Llama a init() primero.');
    }
    return _prefs!;
  }

  // Onboarding
  static Future<bool> setOnboardingCompleted(bool completed) async {
    return await _instance.setBool(_onboardingCompletedKey, completed);
  }

  static bool getOnboardingCompleted() {
    return _instance.getBool(_onboardingCompletedKey) ?? false;
  }

  // First Launch
  static Future<bool> setFirstLaunch(bool isFirst) async {
    return await _instance.setBool(_firstLaunchKey, isFirst);
  }

  static bool isFirstLaunch() {
    return _instance.getBool(_firstLaunchKey) ?? true;
  }

  // Tutorial
  static Future<bool> setTutorialCompleted(bool completed) async {
    return await _instance.setBool(_tutorialCompletedKey, completed);
  }

  static bool getTutorialCompleted() {
    return _instance.getBool(_tutorialCompletedKey) ?? false;
  }

  // Premium Status
  static Future<bool> setPremiumStatus(bool isPremium) async {
    return await _instance.setBool(_premiumStatusKey, isPremium);
  }

  static bool getPremiumStatus() {
    return _instance.getBool(_premiumStatusKey) ?? false;
  }

  // Ad Management
  static Future<bool> setLastAdShown(int timestamp) async {
    return await _instance.setInt(_lastAdShownKey, timestamp);
  }

  static int getLastAdShown() {
    return _instance.getInt(_lastAdShownKey) ?? 0;
  }

  static Future<bool> setAdCount(int count) async {
    return await _instance.setInt(_adCountKey, count);
  }

  static int getAdCount() {
    return _instance.getInt(_adCountKey) ?? 0;
  }

  // Vehicle Selection
  static Future<bool> setSelectedVehicle(String vehicleId) async {
    return await _instance.setString(_selectedVehicleKey, vehicleId);
  }

  static String? getSelectedVehicle() {
    return _instance.getString(_selectedVehicleKey);
  }

  // Currency
  static Future<bool> setSelectedCurrency(String currency) async {
    return await _instance.setString(_selectedCurrencyKey, currency);
  }

  static String getSelectedCurrency() {
    return _instance.getString(_selectedCurrencyKey) ?? 'EUR';
  }

  // Theme
  static Future<void> setThemeMode(String themeMode) async {
    await _prefs?.setString(_themeKey, themeMode);
  }

  static String getThemeMode() {
    return _prefs?.getString(_themeKey) ?? 'system';
  }

  // Language
  static Future<void> setLanguage(String language) async {
    await _prefs?.setString(_languageKey, language);
  }

  static String getLanguage() {
    return _prefs?.getString(_languageKey) ?? 'es';
  }

  // Notifications
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs?.setBool(_notificationsEnabledKey, enabled);
  }

  static bool getNotificationsEnabled() {
    return _prefs?.getBool(_notificationsEnabledKey) ?? true;
  }

  // Analytics
  static Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs?.setBool(_analyticsEnabledKey, enabled);
  }

  static bool getAnalyticsEnabled() {
    return _prefs?.getBool(_analyticsEnabledKey) ?? true;
  }

  /// Limpiar todas las preferencias
  static Future<bool> clearAll() async {
    return await _instance.clear();
  }

  /// Limpiar datos específicos del usuario (mantener configuraciones de app)
  static Future<void> clearUserData() async {
    await _instance.remove(_selectedVehicleKey);
    await _instance.remove(_premiumStatusKey);
    await _instance.remove(_lastAdShownKey);
    await _instance.remove(_adCountKey);
  }
}
