import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'preferences_service.dart';

/// Servicio para manejar suscripciones y compras in-app
class SubscriptionService {
  static const String monthlySubscriptionId = 'automate_premium_monthly';
  static const String yearlySubscriptionId = 'automate_premium_yearly';
  static const String lifetimeSubscriptionId = 'automate_premium_lifetime';

  static const Set<String> _productIds = {
    monthlySubscriptionId,
    yearlySubscriptionId,
    lifetimeSubscriptionId,
  };

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  String? _queryProductError;

  // Callbacks
  Function(bool)? onPremiumStatusChanged;
  Function(String)? onError;
  Function(bool)? onPurchaseStateChanged;

  /// Inicializar el servicio de suscripciones
  Future<void> init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => onError?.call('Error en compras: $error'),
    );

    await _initStoreInfo();
  }

  /// Inicializar información de la tienda
  Future<void> _initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable = false;
      _products = [];
      _purchasePending = false;
      return;
    }

    // iOS platform addition será configurado cuando esté disponible
    // if (Platform.isIOS) {
    //   final iosPlatformAddition = _inAppPurchase.getPlatformAddition();
    //   await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
    // }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_productIds);
    
    if (productDetailResponse.error != null) {
      _queryProductError = productDetailResponse.error!.message;
      _isAvailable = false;
      _products = [];
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _queryProductError = 'No se encontraron productos';
      _isAvailable = false;
      _products = [];
      return;
    }

    _isAvailable = true;
    _products = productDetailResponse.productDetails;
    _purchasePending = false;

    // Verificar compras pendientes
    await _restorePurchases();
  }

  /// Manejar actualizaciones de compras
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      _handlePurchaseUpdate(purchaseDetails);
    }
  }

  /// Procesar actualización de compra individual
  Future<void> _handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      _purchasePending = true;
      onPurchaseStateChanged?.call(true);
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        onError?.call('Error en la compra: ${purchaseDetails.error?.message}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                 purchaseDetails.status == PurchaseStatus.restored) {
        
        // Verificar si la compra es válida
        final bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          await _handleSuccessfulPurchase(purchaseDetails);
        } else {
          onError?.call('Compra no válida');
        }
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }

      _purchasePending = false;
      onPurchaseStateChanged?.call(false);
    }
  }

  /// Verificar validez de la compra
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // En producción, aquí deberías verificar la compra con tu servidor
    // Por ahora, verificamos conectividad y estructura básica
    
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      // Sin internet, aceptar compras locales por ahora
      return true;
    }

    // Verificar que el productId sea válido
    return _productIds.contains(purchaseDetails.productID);
  }

  /// Manejar compra exitosa
  Future<void> _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) async {
    // Activar premium
    await PreferencesService.setPremiumStatus(true);
    onPremiumStatusChanged?.call(true);

    // Log de la compra exitosa
    debugPrint('Compra exitosa: ${purchaseDetails.productID}');
  }

  /// Comprar suscripción
  Future<void> buySubscription(String productId) async {
    if (!_isAvailable) {
      onError?.call('Tienda no disponible');
      return;
    }

    // Verificar conectividad
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      onError?.call('Sin conexión a internet');
      return;
    }

    final ProductDetails? productDetails = _products
        .cast<ProductDetails?>()
        .firstWhere(
          (product) => product?.id == productId,
          orElse: () => null,
        );

    if (productDetails == null) {
      onError?.call('Producto no encontrado');
      return;
    }

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      if (productId == lifetimeSubscriptionId) {
        // Compra única
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        // Suscripción
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      onError?.call('Error al procesar compra: $e');
    }
  }

  /// Restaurar compras
  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      onError?.call('Error al restaurar compras: $e');
    }
  }

  /// Restaurar compras (método público)
  Future<void> restorePurchases() async {
    await _restorePurchases();
  }

  /// Verificar si el usuario tiene premium
  bool get isPremium => PreferencesService.getPremiumStatus();

  /// Verificar si hay compras pendientes
  bool get isPurchasePending => _purchasePending;

  /// Obtener productos disponibles
  List<ProductDetails> get products => _products;

  /// Verificar si la tienda está disponible
  bool get isStoreAvailable => _isAvailable;

  /// Obtener error de consulta de productos
  String? get queryProductError => _queryProductError;

  /// Limpiar estado premium (para testing)
  Future<void> clearPremiumStatus() async {
    await PreferencesService.setPremiumStatus(false);
    onPremiumStatusChanged?.call(false);
  }

  /// Verificar límites de versión gratuita
  bool canAddVehicle(int currentVehicleCount) {
    if (isPremium) return true;
    return currentVehicleCount < 2; // Límite de 2 vehículos en versión gratuita
  }

  /// Verificar si puede exportar datos
  bool canExportData() {
    return isPremium;
  }

  /// Verificar si puede acceder a análisis avanzados
  bool canAccessAdvancedAnalytics() {
    return isPremium;
  }

  /// Disponer recursos
  void dispose() {
    // iOS platform addition será configurado cuando esté disponible
    // if (Platform.isIOS) {
    //   final iosPlatformAddition = _inAppPurchase.getPlatformAddition();
    //   iosPlatformAddition.setDelegate(null);
    // }
    _subscription.cancel();
  }
}
