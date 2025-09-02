import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/subscription_service.dart';

/// Provider para el servicio de suscripciones
final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

/// Provider para el estado de suscripción
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  final service = ref.watch(subscriptionServiceProvider);
  return SubscriptionNotifier(service);
});

/// Estado de suscripción
class SubscriptionState {
  final bool isPremium;
  final bool isPurchasing;
  final bool isLoading;
  final String? error;
  final List<String> availableProducts;

  const SubscriptionState({
    this.isPremium = false,
    this.isPurchasing = false,
    this.isLoading = false,
    this.error,
    this.availableProducts = const [],
  });

  SubscriptionState copyWith({
    bool? isPremium,
    bool? isPurchasing,
    bool? isLoading,
    String? error,
    List<String>? availableProducts,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      availableProducts: availableProducts ?? this.availableProducts,
    );
  }
}

/// Notifier para manejar el estado de suscripción
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final SubscriptionService _service;

  SubscriptionNotifier(this._service) : super(const SubscriptionState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    
    try {
      // Configurar callbacks del servicio
      _service.onPremiumStatusChanged = (isPremium) {
        state = state.copyWith(isPremium: isPremium);
      };
      
      _service.onError = (error) {
        state = state.copyWith(error: error, isPurchasing: false);
      };
      
      _service.onPurchaseStateChanged = (isPurchasing) {
        state = state.copyWith(isPurchasing: isPurchasing);
      };

      // Inicializar servicio
      await _service.init();
      
      // Actualizar estado inicial
      state = state.copyWith(
        isPremium: _service.isPremium,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Error inicializando suscripciones: $e',
        isLoading: false,
      );
    }
  }

  /// Comprar suscripción
  Future<void> purchaseSubscription(String productId) async {
    state = state.copyWith(isPurchasing: true, error: null);
    
    try {
      await _service.buySubscription(productId);
    } catch (e) {
      state = state.copyWith(
        error: 'Error en la compra: $e',
        isPurchasing: false,
      );
      rethrow;
    }
  }

  /// Restaurar compras
  Future<void> restorePurchases() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _service.restorePurchases();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Error restaurando compras: $e',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Verificar si puede agregar vehículo
  bool canAddVehicle(int currentCount) {
    return _service.canAddVehicle(currentCount);
  }

  /// Verificar si puede exportar datos
  bool canExportData() {
    return _service.canExportData();
  }

  /// Verificar si puede acceder a análisis avanzados
  bool canAccessAdvancedAnalytics() {
    return _service.canAccessAdvancedAnalytics();
  }

  /// Limpiar error
  void clearError() {
    state = state.copyWith(error: null);
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
