import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/preferences_service.dart';

/// Pantalla de onboarding para nuevos usuarios
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return IntroductionScreen(
      globalBackgroundColor: theme.colorScheme.surface,
      pages: [
        _buildWelcomePage(theme),
        _buildVehicleManagementPage(theme),
        _buildExpenseTrackingPage(theme),
        _buildMaintenancePage(theme),
        _buildAnalyticsPage(theme),
        _buildPremiumPage(theme),
      ],
      onDone: () => _completeOnboarding(context, ref),
      onSkip: () => _completeOnboarding(context, ref),
      showSkipButton: true,
      skip: Text(
        'Saltar',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: theme.colorScheme.primary,
      ),
      done: Text(
        'Comenzar',
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: theme.colorScheme.primary,
        color: theme.colorScheme.outline,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }

  PageViewModel _buildWelcomePage(ThemeData theme) {
    return PageViewModel(
      title: "¡Bienvenido a AutoMate!",
      body: "La aplicación más completa para gestionar todos los aspectos de tus vehículos de manera inteligente y eficiente.",
      image: _buildPageImage(
        Icons.directions_car,
        theme.colorScheme.primary,
        theme,
      ),
      decoration: _getPageDecoration(theme),
    );
  }

  PageViewModel _buildVehicleManagementPage(ThemeData theme) {
    return PageViewModel(
      title: "Gestiona tus Vehículos",
      body: "Registra todos tus vehículos con información detallada: marca, modelo, año, kilometraje y mucho más.",
      image: _buildPageImage(
        Icons.garage,
        Colors.blue,
        theme,
      ),
      decoration: _getPageDecoration(theme),
    );
  }

  PageViewModel _buildExpenseTrackingPage(ThemeData theme) {
    return PageViewModel(
      title: "Controla tus Gastos",
      body: "Registra combustible, reparaciones, seguros y todos los gastos relacionados con tus vehículos.",
      image: _buildPageImage(
        Icons.receipt_long,
        Colors.green,
        theme,
      ),
      decoration: _getPageDecoration(theme),
    );
  }

  PageViewModel _buildMaintenancePage(ThemeData theme) {
    return PageViewModel(
      title: "Mantenimiento Inteligente",
      body: "Recibe recordatorios automáticos para cambios de aceite, revisiones y mantenimientos preventivos.",
      image: _buildPageImage(
        Icons.build_circle,
        Colors.orange,
        theme,
      ),
      decoration: _getPageDecoration(theme),
    );
  }

  PageViewModel _buildAnalyticsPage(ThemeData theme) {
    return PageViewModel(
      title: "Análisis y Estadísticas",
      body: "Visualiza gráficos detallados de consumo, gastos mensuales y tendencias de tus vehículos.",
      image: _buildPageImage(
        Icons.analytics,
        Colors.purple,
        theme,
      ),
      decoration: _getPageDecoration(theme),
    );
  }

  PageViewModel _buildPremiumPage(ThemeData theme) {
    return PageViewModel(
      title: "Desbloquea el Potencial Completo",
      body: "Actualiza a Premium para vehículos ilimitados, exportación de datos, análisis avanzados y sin anuncios.",
      image: _buildPageImage(
        Icons.workspace_premium,
        Colors.amber,
        theme,
      ),
      decoration: _getPageDecoration(theme),
    );
  }

  Widget _buildPageImage(IconData icon, Color color, ThemeData theme) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 100,
        color: color,
      ),
    );
  }

  PageDecoration _getPageDecoration(ThemeData theme) {
    return PageDecoration(
      titleTextStyle: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ) ?? const TextStyle(),
      bodyTextStyle: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.5,
      ) ?? const TextStyle(),
      imagePadding: const EdgeInsets.only(top: 40, bottom: 40),
      contentMargin: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Future<void> _completeOnboarding(BuildContext context, WidgetRef ref) async {
    // Marcar onboarding como completado
    await PreferencesService.setOnboardingCompleted(true);
    
    // Navegar a login o dashboard según el estado de auth
    final authState = ref.read(authNotifierProvider);
    if (authState.isAuthenticated) {
      context.go('/dashboard');
    } else {
      context.go('/login');
    }
  }
}
