import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Modelo para monedas soportadas
class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });
}

/// Monedas disponibles en la aplicación
class AppCurrencies {
  static const List<Currency> currencies = [
    Currency(code: 'EUR', name: 'Euro', symbol: '€'),
    Currency(code: 'USD', name: 'Dólar Americano', symbol: '\$'),
    Currency(code: 'CLP', name: 'Peso Chileno', symbol: '\$'),
    Currency(code: 'COP', name: 'Peso Colombiano', symbol: '\$'),
    Currency(code: 'MXN', name: 'Peso Mexicano', symbol: '\$'),
    Currency(code: 'ARS', name: 'Peso Argentino', symbol: '\$'),
    Currency(code: 'GBP', name: 'Libra Esterlina', symbol: '£'),
    Currency(code: 'JPY', name: 'Yen Japonés', symbol: '¥'),
    Currency(code: 'CAD', name: 'Dólar Canadiense', symbol: 'C\$'),
  ];

  static Currency getCurrency(String code) {
    return currencies.firstWhere(
      (currency) => currency.code == code,
      orElse: () => currencies.first, // EUR por defecto
    );
  }
}

/// Notificador para la gestión de moneda global
class CurrencyNotifier extends StateNotifier<Currency> {
  static const String _currencyKey = 'selected_currency';

  CurrencyNotifier() : super(AppCurrencies.currencies.first) {
    _loadSavedCurrency();
  }

  /// Carga la moneda guardada desde SharedPreferences
  Future<void> _loadSavedCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCurrencyCode = prefs.getString(_currencyKey);
      
      if (savedCurrencyCode != null) {
        final currency = AppCurrencies.getCurrency(savedCurrencyCode);
        state = currency;
      }
    } catch (e) {
      // Si hay error, mantener EUR por defecto
      print('Error loading saved currency: $e');
    }
  }

  /// Cambia la moneda seleccionada
  Future<void> setCurrency(Currency currency) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyKey, currency.code);
      state = currency;
    } catch (e) {
      print('Error saving currency: $e');
    }
  }

  /// Obtiene el símbolo de la moneda actual
  String get symbol => state.symbol;

  /// Obtiene el código de la moneda actual
  String get code => state.code;

  /// Formatea un monto con la moneda actual
  String formatAmount(double amount) {
    return '${state.symbol}${amount.toStringAsFixed(2)}';
  }
}

/// Provider para la moneda global
final currencyNotifierProvider = StateNotifierProvider<CurrencyNotifier, Currency>(
  (ref) => CurrencyNotifier(),
);
