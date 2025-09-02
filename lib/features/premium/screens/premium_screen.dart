import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/services/subscription_service.dart';
import '../widgets/premium_feature_card.dart';
import '../widgets/subscription_plan_card.dart';

/// Pantalla de suscripción premium
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subscriptionState = ref.watch(subscriptionProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('AutoMate Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono premium
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.workspace_premium,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Desbloquea todo el potencial',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accede a todas las funciones premium sin limitaciones',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Características premium
            Text(
              'Características Premium',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const PremiumFeatureCard(
              icon: Icons.directions_car,
              title: 'Vehículos Ilimitados',
              description: 'Registra todos tus vehículos sin límites',
              isIncluded: true,
            ),
            const SizedBox(height: 12),

            const PremiumFeatureCard(
              icon: Icons.block,
              title: 'Sin Anuncios',
              description: 'Experiencia completamente libre de publicidad',
              isIncluded: true,
            ),
            const SizedBox(height: 12),

            const PremiumFeatureCard(
              icon: Icons.file_download,
              title: 'Exportar Datos',
              description: 'Exporta tus datos en CSV, PDF y Excel',
              isIncluded: true,
            ),
            const SizedBox(height: 12),

            const PremiumFeatureCard(
              icon: Icons.analytics,
              title: 'Análisis Avanzados',
              description: 'Gráficos detallados y estadísticas avanzadas',
              isIncluded: true,
            ),
            const SizedBox(height: 12),

            const PremiumFeatureCard(
              icon: Icons.cloud_sync,
              title: 'Sincronización en la Nube',
              description: 'Accede a tus datos desde cualquier dispositivo',
              isIncluded: true,
            ),
            const SizedBox(height: 12),

            const PremiumFeatureCard(
              icon: Icons.support_agent,
              title: 'Soporte Prioritario',
              description: 'Atención al cliente prioritaria y personalizada',
              isIncluded: true,
            ),

            const SizedBox(height: 32),

            // Planes de suscripción
            Text(
              'Elige tu Plan',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Plan mensual
            SubscriptionPlanCard(
              title: 'Mensual',
              price: '6,99 €',
              period: '/mes',
              originalPrice: null,
              savings: null,
              features: const [
                'Todas las características premium',
                'Cancela cuando quieras',
                'Soporte prioritario',
              ],
              isPopular: false,
              onTap: () => _purchaseSubscription(SubscriptionService.monthlySubscriptionId),
              isLoading: subscriptionState.isPurchasing,
            ),

            const SizedBox(height: 16),

            // Plan anual (popular)
            SubscriptionPlanCard(
              title: 'Anual',
              price: '50 €',
              period: '/año',
              originalPrice: '83,88 €',
              savings: 'Ahorra 40%',
              features: const [
                'Todas las características premium',
                'Ahorra más de 30€ al año',
                'Soporte prioritario',
                '2 meses gratis',
              ],
              isPopular: true,
              onTap: () => _purchaseSubscription(SubscriptionService.yearlySubscriptionId),
              isLoading: subscriptionState.isPurchasing,
            ),

            const SizedBox(height: 16),

            // Plan de por vida
            SubscriptionPlanCard(
              title: 'De por vida',
              price: '699 €',
              period: 'pago único',
              originalPrice: null,
              savings: 'Mejor valor',
              features: const [
                'Todas las características premium',
                'Acceso de por vida',
                'Todas las futuras actualizaciones',
                'Soporte prioritario de por vida',
              ],
              isPopular: false,
              onTap: () => _purchaseSubscription(SubscriptionService.lifetimeSubscriptionId),
              isLoading: subscriptionState.isPurchasing,
            ),

            const SizedBox(height: 32),

            // Botón para restaurar compras
            Center(
              child: TextButton(
                onPressed: _restorePurchases,
                child: const Text('Restaurar Compras'),
              ),
            ),

            const SizedBox(height: 16),

            // Términos y condiciones
            Center(
              child: Column(
                children: [
                  Text(
                    'Al suscribirte, aceptas nuestros',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: _openTermsOfService,
                        child: const Text('Términos de Servicio'),
                      ),
                      Text(
                        ' y ',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: _openPrivacyPolicy,
                        child: const Text('Política de Privacidad'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _purchaseSubscription(String productId) async {
    try {
      await ref.read(subscriptionProvider.notifier).purchaseSubscription(productId);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido a Premium!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en la compra: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await ref.read(subscriptionProvider.notifier).restorePurchases();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compras restauradas exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error restaurando compras: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _openTermsOfService() {
    context.push('/terms');
  }

  void _openPrivacyPolicy() {
    context.push('/privacy');
  }
}
