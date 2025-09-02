import 'package:flutter/material.dart';

/// Widget para mostrar una característica premium
class PremiumFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isIncluded;

  const PremiumFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.isIncluded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isIncluded 
                  ? theme.colorScheme.primary.withOpacity(0.1)
                  : theme.colorScheme.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isIncluded 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.error,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isIncluded ? Icons.check_circle : Icons.cancel,
            color: isIncluded 
                ? Colors.green
                : theme.colorScheme.error,
            size: 20,
          ),
        ],
      ),
    );
  }
}
