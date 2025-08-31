import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pantalla de gestión de mantenimientos
class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Mantenimiento'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Implementar vista de calendario
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementar filtros
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Pantalla de Mantenimiento - En desarrollo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Agregar nuevo mantenimiento
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
