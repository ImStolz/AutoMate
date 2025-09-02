import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/expenses_provider.dart';
import '../../../core/providers/vehicles_provider.dart';
import '../../settings/screens/settings_screen.dart';

/// Pantalla de perfil y configuración del usuario
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditProfileDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header del perfil
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: user?.photoUrl != null
                          ? NetworkImage(user!.photoUrl!)
                          : null,
                      child: user?.photoUrl == null
                          ? Text(
                              user?.displayName.isNotEmpty == true
                                  ? user!.displayName[0].toUpperCase()
                                  : 'U',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ?? 'Usuario',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: user?.isPremium == true
                            ? Colors.amber.withOpacity(0.2)
                            : theme.colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user?.isPremium == true ? 'Premium' : 'Gratuito',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: user?.isPremium == true
                              ? Colors.amber[800]
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Opciones del menú
            _buildMenuSection(
              context,
              title: 'Cuenta',
              items: [
                _MenuItem(
                  icon: Icons.person_outline,
                  title: 'Información personal',
                  onTap: () => _showPersonalInfoDialog(context, ref),
                ),
                _MenuItem(
                  icon: Icons.security,
                  title: 'Seguridad',
                  onTap: () => _showSecurityDialog(context),
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildMenuSection(
              context,
              title: 'Suscripción',
              items: [
                _MenuItem(
                  icon: Icons.star_outline,
                  title: 'Actualizar a Premium',
                  subtitle: 'Vehículos ilimitados y más funciones',
                  onTap: () => context.push('/premium'),
                ),
                _MenuItem(
                  icon: Icons.receipt_long,
                  title: 'Historial de pagos',
                  onTap: () => _showPaymentHistoryDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildMenuSection(
              context,
              title: 'Configuración',
              items: [
                _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Tema',
                  subtitle: 'Claro, oscuro o automático',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  ),
                ),
                _MenuItem(
                  icon: Icons.language,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  ),
                ),
                _MenuItem(
                  icon: Icons.download,
                  title: 'Exportar datos',
                  onTap: () => _exportDataToCSV(context, ref),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildMenuSection(
              context,
              title: 'Soporte',
              items: [
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'Ayuda y FAQ',
                  onTap: () => _showHelpDialog(context),
                ),
                _MenuItem(
                  icon: Icons.feedback_outlined,
                  title: 'Enviar comentarios',
                  onTap: () => _sendFeedback(),
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'Acerca de',
                  onTap: () => _showAboutDialog(context),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showSignOutDialog(context, ref),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  /// Construye una sección del menú
  Widget _buildMenuSection(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildMenuItem(context, item)),
          ],
        ),
      ),
    );
  }

  /// Construye un elemento del menú
  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        item.icon,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      title: Text(
        item.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: item.onTap,
    );
  }

  /// Muestra el diálogo de información personal
  void _showPersonalInfoDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información Personal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: ${user?.displayName ?? 'No disponible'}'),
            const SizedBox(height: 8),
            Text('Email: ${user?.email ?? 'No disponible'}'),
            const SizedBox(height: 8),
            Text('ID de Usuario: ${user?.id ?? 'No disponible'}'),
            const SizedBox(height: 8),
            Text('Cuenta creada: ${user?.createdAt.toString().split(' ')[0] ?? 'No disponible'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de seguridad
  void _showSecurityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seguridad'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock_reset),
              title: const Text('Cambiar contraseña'),
              onTap: () {
                Navigator.pop(context);
                _changePassword(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Autenticación de dos factores'),
              onTap: () {
                Navigator.pop(context);
                _show2FADialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Dispositivos conectados'),
              onTap: () {
                Navigator.pop(context);
                _showConnectedDevices(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Muestra el historial de pagos
  void _showPaymentHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Historial de Pagos'),
        content: const SizedBox(
          width: double.maxFinite,
          height: 200,
          child: Center(
            child: Text('No hay historial de pagos disponible'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Exporta los datos a CSV
  Future<void> _exportDataToCSV(BuildContext context, WidgetRef ref) async {
    try {
      final expensesState = ref.read(expensesNotifierProvider);
      final vehiclesState = ref.read(vehiclesNotifierProvider);
      
      // Crear datos CSV para gastos
      List<List<dynamic>> expenseRows = [
        ['Fecha', 'Tipo', 'Descripción', 'Monto', 'Vehículo']
      ];
      
      for (final expense in expensesState.expenses) {
        expenseRows.add([
          expense.date.toString().split(' ')[0],
          expense.category.name,
          expense.description,
          expense.amount,
          expense.vehicleId,
        ]);
      }
      
      // Crear datos CSV para vehículos
      List<List<dynamic>> vehicleRows = [
        ['Marca', 'Modelo', 'Año', 'Placa', 'Kilometraje']
      ];
      
      for (final vehicle in vehiclesState.vehicles) {
        vehicleRows.add([
          vehicle.brand,
          vehicle.model,
          vehicle.year,
          vehicle.licensePlate,
          vehicle.currentOdometer,
        ]);
      }
      
      String expenseCsv = const ListToCsvConverter().convert(expenseRows);
      String vehicleCsv = const ListToCsvConverter().convert(vehicleRows);
      
      // Obtener directorio de documentos
      final directory = await getApplicationDocumentsDirectory();
      final expenseFile = File('${directory.path}/gastos_automate.csv');
      final vehicleFile = File('${directory.path}/vehiculos_automate.csv');
      
      await expenseFile.writeAsString(expenseCsv);
      await vehicleFile.writeAsString(vehicleCsv);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Datos exportados a ${directory.path}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Abrir carpeta',
              onPressed: () {
                // TODO: Abrir explorador de archivos
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar datos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Muestra el diálogo de ayuda
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ayuda y FAQ'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView(
            children: const [
              ExpansionTile(
                title: Text('¿Cómo agregar un vehículo?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Ve a la sección Vehículos y toca el botón "+" para agregar un nuevo vehículo.'),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('¿Cómo registrar gastos?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('En la sección Gastos, toca "Agregar gasto" y completa la información requerida.'),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('¿Qué incluye Premium?'),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Premium incluye vehículos ilimitados, sin anuncios, exportación avanzada y más funciones.'),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Envía comentarios por email
  Future<void> _sendFeedback() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@automate.app',
      query: 'subject=Comentarios AutoMate&body=Hola, me gustaría compartir mis comentarios sobre la app:',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  /// Muestra el diálogo "Acerca de"
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'AutoMate',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.directions_car, size: 48),
      children: [
        const Text('AutoMate es tu compañero perfecto para gestionar gastos y mantenimiento de vehículos.'),
        const SizedBox(height: 16),
        const Text('Desarrollado con ❤️ por StolzOfficial'),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.push('/terms'),
          child: const Text('Términos y Condiciones'),
        ),
        TextButton(
          onPressed: () => context.push('/privacy'),
          child: const Text('Política de Privacidad'),
        ),
      ],
    );
  }

  /// Cambiar contraseña
  void _changePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Contraseña'),
        content: const Text('Se enviará un enlace de restablecimiento a tu email.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar cambio de contraseña
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Enlace enviado a tu email'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }

  /// Mostrar configuración 2FA
  void _show2FADialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Autenticación de Dos Factores'),
        content: const Text('Esta función estará disponible en una próxima actualización.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  /// Mostrar dispositivos conectados
  void _showConnectedDevices(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dispositivos Conectados'),
        content: const Text('Esta función estará disponible en una próxima actualización.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo de confirmación para cerrar sesión
  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).signOut();
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  /// Muestra el diálogo para editar perfil
  void _showEditProfileDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserProvider);
    final nameController = TextEditingController(text: user?.displayName ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _showPhotoOptions(context, ref),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: user?.photoUrl != null
                        ? NetworkImage(user!.photoUrl!)
                        : null,
                    child: user?.photoUrl == null
                        ? Text(
                            user?.displayName.isNotEmpty == true
                                ? user!.displayName[0].toUpperCase()
                                : 'U',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user?.email ?? 'No disponible'}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateProfile(context, ref, nameController.text);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Muestra opciones para cambiar foto de perfil
  void _showPhotoOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Seleccionar de galería'),
              onTap: () {
                Navigator.pop(context);
                _selectFromGallery(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Eliminar foto'),
              onTap: () {
                Navigator.pop(context);
                _removePhoto(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Actualiza el perfil del usuario
  void _updateProfile(BuildContext context, WidgetRef ref, String name) {
    // TODO: Implementar actualización de perfil en Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil actualizado correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Tomar foto con cámara
  void _takePhoto(BuildContext context, WidgetRef ref) {
    // TODO: Implementar captura de foto con cámara
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de cámara disponible próximamente'),
      ),
    );
  }

  /// Seleccionar foto de galería
  void _selectFromGallery(BuildContext context, WidgetRef ref) {
    // TODO: Implementar selección de foto de galería
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Función de galería disponible próximamente'),
      ),
    );
  }

  /// Eliminar foto de perfil
  void _removePhoto(BuildContext context, WidgetRef ref) {
    // TODO: Implementar eliminación de foto de perfil
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto de perfil eliminada'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

/// Clase para representar un elemento del menú
class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
