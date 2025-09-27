import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final Widget? action;

  const EmptyState({
    Key? key,
    required this.message,
    this.icon = Icons.inbox,
    this.iconSize = 48.0,
    this.spacing = 16.0,
    this.padding,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: theme.disabledColor.withOpacity(0.5),
          ),
          SizedBox(height: spacing),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.disabledColor,
            ),
          ),
          if (action != null) ...[
            SizedBox(height: spacing / 2),
            action!,
          ],
        ],
      ),
    );
  }
}
