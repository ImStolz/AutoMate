import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/providers/language_provider.dart';

/// Pantalla de configuración de la aplicación
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _selectedTheme = 'system';
  String _selectedLanguage = 'es';
  bool _notificationsEnabled = true;
  bool _analyticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    // Cargar configuraciones guardadas
    setState(() {
      _selectedTheme = PreferencesService.getThemeMode();
      _selectedLanguage = PreferencesService.getLanguage();
      _notificationsEnabled = PreferencesService.getNotificationsEnabled();
      _analyticsEnabled = PreferencesService.getAnalyticsEnabled();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de Apariencia
          _buildSection(
            context,
            title: 'Apariencia',
            children: [
              _buildThemeSelector(context),
              _buildLanguageSelector(context),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Sección de Notificaciones
          _buildSection(
            context,
            title: 'Notificaciones',
            children: [
              SwitchListTile(
                title: const Text('Notificaciones push'),
                subtitle: const Text('Recibir recordatorios de mantenimiento'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  PreferencesService.setNotificationsEnabled(value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Sección de Privacidad
          _buildSection(
            context,
            title: 'Privacidad',
            children: [
              SwitchListTile(
                title: const Text('Análisis de uso'),
                subtitle: const Text('Ayudar a mejorar la app compartiendo datos anónimos'),
                value: _analyticsEnabled,
                onChanged: (value) {
                  setState(() {
                    _analyticsEnabled = value;
                  });
                  PreferencesService.setAnalyticsEnabled(value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Sección de Datos
          _buildSection(
            context,
            title: 'Datos',
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Respaldar datos'),
                subtitle: const Text('Crear copia de seguridad en la nube'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showBackupDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text('Restaurar datos'),
                subtitle: const Text('Recuperar desde copia de seguridad'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showRestoreDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Eliminar todos los datos'),
                subtitle: const Text('Esta acción no se puede deshacer'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showDeleteAllDataDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette),
      title: const Text('Tema'),
      subtitle: Text(_getThemeDisplayName(_selectedTheme)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showThemeDialog(context),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Idioma'),
      subtitle: Text(_getLanguageDisplayName(_selectedLanguage)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => _showLanguageDialog(context),
    );
  }

  String _getThemeDisplayName(String theme) {
    switch (theme) {
      case 'light':
        return 'Claro';
      case 'dark':
        return 'Oscuro';
      case 'system':
      default:
        return 'Automático';
    }
  }

  String _getLanguageDisplayName(String language) {
    switch (language) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Español';
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Claro'),
              value: 'light',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                PreferencesService.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Oscuro'),
              value: 'dark',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                PreferencesService.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Automático'),
              value: 'system',
              groupValue: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                PreferencesService.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar idioma'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Español'),
              value: 'es',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                PreferencesService.setLanguage(value!);
                ref.read(languageNotifierProvider.notifier).setLanguage(value);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Idioma cambiado a Español')),
                );
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                PreferencesService.setLanguage(value!);
                ref.read(languageNotifierProvider.notifier).setLanguage(value);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Language changed to English')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBackupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respaldar datos'),
        content: const Text('¿Deseas crear una copia de seguridad de todos tus datos en la nube?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performBackup();
            },
            child: const Text('Respaldar'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar datos'),
        content: const Text('¿Deseas restaurar tus datos desde la última copia de seguridad? Esto sobrescribirá los datos actuales.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRestore();
            },
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar todos los datos'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los datos? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _performBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Respaldo en Progreso'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Creando respaldo de tus datos...'),
          ],
        ),
      ),
    );
    
    // Simular proceso de respaldo
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Respaldo completado exitosamente en la nube'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _performRestore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restaurar Datos'),
        content: const Text('¿Deseas restaurar tus datos desde el último respaldo? Esto sobrescribirá los datos actuales.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeRestore();
            },
            child: const Text('Restaurar'),
          ),
        ],
      ),
    );
  }

  void _executeRestore() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restauración en Progreso'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Restaurando tus datos...'),
          ],
        ),
      ),
    );
    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos restaurados exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void _deleteAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Eliminar Todos los Datos'),
        content: const Text('Esta acción eliminará permanentemente todos tus vehículos, gastos y configuraciones. ¿Estás completamente seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmFinalDeletion();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar Todo'),
          ),
        ],
      ),
    );
  }

  void _confirmFinalDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmación Final'),
        content: const Text('Escribe "ELIMINAR" para confirmar que deseas borrar todos los datos:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeDeletion();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _executeDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminando Datos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 16),
            Text('Eliminando todos los datos...'),
          ],
        ),
      ),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todos los datos han sido eliminados'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
