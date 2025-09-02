import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pantalla de Política de Privacidad
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política de Privacidad'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Política de Privacidad',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Última actualización: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              theme,
              '1. Introducción',
              'En AutoMate, respetamos su privacidad y nos comprometemos a proteger sus datos personales. Esta Política de Privacidad explica cómo recopilamos, usamos, almacenamos y protegemos su información cuando utiliza nuestra aplicación.',
            ),
            
            _buildSection(
              theme,
              '2. Información que Recopilamos',
              'Recopilamos la siguiente información:\n\n• Información de cuenta: email, nombre, foto de perfil\n• Datos de vehículos: marca, modelo, año, kilometraje\n• Registros de gastos: combustible, mantenimiento, reparaciones\n• Datos de uso: interacciones con la aplicación\n• Información del dispositivo: modelo, sistema operativo, identificadores únicos',
            ),
            
            _buildSection(
              theme,
              '3. Cómo Utilizamos su Información',
              'Utilizamos sus datos para:\n\n• Proporcionar y mejorar nuestros servicios\n• Personalizar su experiencia en la aplicación\n• Procesar suscripciones y pagos\n• Enviar notificaciones importantes\n• Analizar el uso para mejorar la aplicación\n• Cumplir con obligaciones legales',
            ),
            
            _buildSection(
              theme,
              '4. Almacenamiento y Seguridad',
              'Sus datos se almacenan de forma segura utilizando:\n\n• Cifrado en tránsito y en reposo\n• Servidores seguros de Firebase/Google Cloud\n• Acceso restringido solo a personal autorizado\n• Copias de seguridad regulares\n• Monitoreo continuo de seguridad',
            ),
            
            _buildSection(
              theme,
              '5. Compartir Información',
              'No vendemos ni alquilamos sus datos personales. Podemos compartir información limitada con:\n\n• Proveedores de servicios (Firebase, Google Play)\n• Autoridades legales cuando sea requerido por ley\n• Terceros con su consentimiento explícito',
            ),
            
            _buildSection(
              theme,
              '6. Cookies y Tecnologías de Seguimiento',
              'Utilizamos tecnologías similares para:\n\n• Mantener su sesión activa\n• Recordar sus preferencias\n• Analizar el uso de la aplicación\n• Personalizar anuncios (solo en versión gratuita)\n• Mejorar el rendimiento',
            ),
            
            _buildSection(
              theme,
              '7. Sus Derechos',
              'Usted tiene derecho a:\n\n• Acceder a sus datos personales\n• Rectificar información incorrecta\n• Eliminar su cuenta y datos\n• Portabilidad de datos\n• Oponerse al procesamiento\n• Retirar el consentimiento en cualquier momento',
            ),
            
            _buildSection(
              theme,
              '8. Retención de Datos',
              'Conservamos sus datos mientras:\n\n• Su cuenta esté activa\n• Sea necesario para proporcionar servicios\n• Lo requiera la ley\n• Tenga suscripciones activas\n\nCuando elimine su cuenta, sus datos se borrarán dentro de 30 días.',
            ),
            
            _buildSection(
              theme,
              '9. Transferencias Internacionales',
              'Sus datos pueden procesarse en países fuera de la UE. Garantizamos protecciones adecuadas mediante:\n\n• Cláusulas contractuales estándar\n• Certificaciones de privacidad\n• Marcos legales apropiados',
            ),
            
            _buildSection(
              theme,
              '10. Menores de Edad',
              'AutoMate no está dirigida a menores de 16 años. No recopilamos conscientemente datos de menores. Si descubrimos que hemos recopilado datos de un menor, los eliminaremos inmediatamente.',
            ),
            
            _buildSection(
              theme,
              '11. Cambios en esta Política',
              'Podemos actualizar esta política ocasionalmente. Le notificaremos cambios significativos a través de la aplicación o por email. El uso continuado constituye aceptación de los cambios.',
            ),
            
            _buildSection(
              theme,
              '12. Contacto',
              'Para ejercer sus derechos o hacer preguntas sobre privacidad:\n\nEmail: privacy@automate-app.com\nDelegado de Protección de Datos: dpo@automate-app.com\nDirección: [Dirección de la empresa]',
            ),
            
            _buildSection(
              theme,
              '13. Autoridad de Control',
              'Si no está satisfecho con nuestro manejo de sus datos, puede presentar una queja ante la Agencia Española de Protección de Datos (AEPD) en www.aepd.es',
            ),
            
            const SizedBox(height: 32),
            
            // Botón de aceptar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Acepto la Política de Privacidad'),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botón de rechazar
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No Acepto'),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
