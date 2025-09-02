import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'preferences_service.dart';

/// Servicio para manejar anuncios de Google AdMob
class AdsService {
  // IDs de anuncios (reemplazar con IDs reales de AdMob)
  static final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
      : 'ca-app-pub-3940256099942544/2934735716'; // Test ID

  static final String _interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712' // Test ID
      : 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  static final String _rewardedAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917' // Test ID
      : 'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // Configuración de frecuencia de anuncios
  static const int _minTimeBetweenInterstitialAds = 300; // 5 minutos en segundos
  static const int _maxAdsPerSession = 10;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isBannerAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  // Callbacks
  Function(bool)? onBannerAdLoaded;
  Function(String)? onAdError;
  Function()? onInterstitialAdClosed;
  Function()? onRewardedAdRewarded;

  /// Inicializar el servicio de anuncios
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Verificar si se deben mostrar anuncios
  bool get shouldShowAds {
    return !PreferencesService.getPremiumStatus();
  }

  /// Verificar conectividad antes de cargar anuncios
  Future<bool> _hasInternetConnection() async {
    final connectivity = await Connectivity().checkConnectivity();
    return connectivity != ConnectivityResult.none;
  }

  /// Verificar si puede mostrar anuncio intersticial
  bool _canShowInterstitialAd() {
    if (!shouldShowAds) return false;

    final lastAdShown = PreferencesService.getLastAdShown();
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeSinceLastAd = currentTime - lastAdShown;

    if (timeSinceLastAd < _minTimeBetweenInterstitialAds) {
      return false;
    }

    final adCount = PreferencesService.getAdCount();
    if (adCount >= _maxAdsPerSession) {
      return false;
    }

    return true;
  }

  /// Cargar anuncio banner
  Future<void> loadBannerAd() async {
    if (!shouldShowAds || !await _hasInternetConnection()) {
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerAdLoaded = true;
          onBannerAdLoaded?.call(true);
        },
        onAdFailedToLoad: (ad, error) {
          _isBannerAdLoaded = false;
          onBannerAdLoaded?.call(false);
          onAdError?.call('Error cargando banner: ${error.message}');
          ad.dispose();
        },
        onAdOpened: (ad) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (ad) {
          debugPrint('Banner ad closed');
        },
      ),
    );

    await _bannerAd!.load();
  }

  /// Cargar anuncio intersticial
  Future<void> loadInterstitialAd() async {
    if (!shouldShowAds || !await _hasInternetConnection()) {
      return;
    }

    await InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          
          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('Interstitial ad showed');
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              onInterstitialAdClosed?.call();
              
              // Precargar el siguiente anuncio
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded = false;
              onAdError?.call('Error mostrando intersticial: ${error.message}');
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isInterstitialAdLoaded = false;
          onAdError?.call('Error cargando intersticial: ${error.message}');
        },
      ),
    );
  }

  /// Cargar anuncio recompensado
  Future<void> loadRewardedAd() async {
    if (!await _hasInternetConnection()) {
      return;
    }

    await RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;
          
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              debugPrint('Rewarded ad showed');
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdLoaded = false;
              
              // Precargar el siguiente anuncio
              loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _isRewardedAdLoaded = false;
              onAdError?.call('Error mostrando recompensado: ${error.message}');
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isRewardedAdLoaded = false;
          onAdError?.call('Error cargando recompensado: ${error.message}');
        },
      ),
    );
  }

  /// Mostrar anuncio intersticial
  Future<void> showInterstitialAd() async {
    if (!_canShowInterstitialAd() || !_isInterstitialAdLoaded || _interstitialAd == null) {
      return;
    }

    await _interstitialAd!.show();
    
    // Actualizar contadores
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await PreferencesService.setLastAdShown(currentTime);
    
    final adCount = PreferencesService.getAdCount();
    await PreferencesService.setAdCount(adCount + 1);
  }

  /// Mostrar anuncio recompensado
  Future<void> showRewardedAd() async {
    if (!_isRewardedAdLoaded || _rewardedAd == null) {
      return;
    }

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        onRewardedAdRewarded?.call();
        debugPrint('Usuario ganó recompensa: ${reward.amount} ${reward.type}');
      },
    );
  }

  /// Obtener widget de banner
  Widget? getBannerAdWidget() {
    if (!shouldShowAds || !_isBannerAdLoaded || _bannerAd == null) {
      return null;
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// Verificar si el banner está cargado
  bool get isBannerAdLoaded => _isBannerAdLoaded && shouldShowAds;

  /// Verificar si el intersticial está cargado
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded && shouldShowAds;

  /// Verificar si el recompensado está cargado
  bool get isRewardedAdLoaded => _isRewardedAdLoaded;

  /// Mostrar anuncio en momentos estratégicos
  Future<void> showAdOnAction(String action) async {
    if (!shouldShowAds) return;

    // Definir acciones que pueden mostrar anuncios
    final adTriggerActions = [
      'add_vehicle',
      'add_expense',
      'export_data',
      'view_analytics',
      'edit_vehicle',
    ];

    if (adTriggerActions.contains(action)) {
      await showInterstitialAd();
    }
  }

  /// Limpiar contadores de anuncios (llamar al inicio de sesión)
  Future<void> resetAdCounters() async {
    await PreferencesService.setAdCount(0);
  }

  /// Disponer recursos
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
