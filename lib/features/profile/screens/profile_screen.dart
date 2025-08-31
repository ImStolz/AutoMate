import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';

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
            onPressed: () {
              // TODO: Editar perfil
            },
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
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.security,
                  title: 'Seguridad',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notificaciones',
                  onTap: () {},
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
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.receipt_long,
                  title: 'Historial de pagos',
                  onTap: () {},
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
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.language,
                  title: 'Idioma',
                  subtitle: 'Español',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.download,
                  title: 'Exportar datos',
                  onTap: () {},
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
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.feedback_outlined,
                  title: 'Enviar comentarios',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'Acerca de',
                  onTap: () {},
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
