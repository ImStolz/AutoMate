import 'package:flutter/material.dart';

/// Badge premium para mostrar funcionalidades exclusivas
class PremiumBadge extends StatelessWidget {
  final bool showIcon;
  final double size;

  const PremiumBadge({
    super.key,
    this.showIcon = true,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size * 0.5,
        vertical: size * 0.25,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.amber, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.75),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              Icons.star,
              color: Colors.white,
              size: size,
            ),
            SizedBox(width: size * 0.25),
          ],
          Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.75,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para bloquear funcionalidades premium
class PremiumLockWidget extends StatelessWidget {
  final String feature;
  final VoidCallback? onUpgrade;

  const PremiumLockWidget({
    super.key,
    required this.feature,
    this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock,
            size: 48,
            color: Colors.amber[700],
          ),
          const SizedBox(height: 16),
          const PremiumBadge(size: 20),
          const SizedBox(height: 12),
          Text(
            feature,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Esta función está disponible solo para usuarios Premium',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (onUpgrade != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onUpgrade,
              icon: const Icon(Icons.upgrade),
              label: const Text('Actualizar a Premium'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
