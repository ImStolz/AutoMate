import 'package:flutter/material.dart';

/// Widget que muestra recordatorios de mantenimiento próximos
class MaintenanceReminders extends StatelessWidget {
  const MaintenanceReminders({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // TODO: Reemplazar con datos reales del provider
    final reminders = _getSampleReminders();
    
    if (reminders.isEmpty) {
      return Card(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Todo al día',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'No tienes mantenimientos pendientes',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: reminders.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                // Indicador de urgencia
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: reminder.urgencyColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Icono de mantenimiento
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: reminder.urgencyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    reminder.icon,
                    color: reminder.urgencyColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Información del recordatorio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reminder.vehicleName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reminder.dueInfo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: reminder.urgencyColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botón de acción
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 16),
                  onPressed: () {
                    // TODO: Navegar a detalles del mantenimiento
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Obtiene recordatorios reales del usuario
  List<MaintenanceReminderItem> _getSampleReminders() {
    // TODO: Implementar conexión con provider de mantenimientos reales
    // Por ahora retorna lista vacía para no mostrar datos de prueba
    return [];
  }
}

/// Clase para representar un recordatorio de mantenimiento
class MaintenanceReminderItem {
  final String title;
  final String vehicleName;
  final String dueInfo;
  final IconData icon;
  final Color urgencyColor;

  const MaintenanceReminderItem({
    required this.title,
    required this.vehicleName,
    required this.dueInfo,
    required this.icon,
    required this.urgencyColor,
  });
}
