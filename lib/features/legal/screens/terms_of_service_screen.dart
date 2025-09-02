import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Pantalla de Términos y Condiciones de Servicio
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Términos y Condiciones de Uso',
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
              '1. Aceptación de los Términos',
              'Al descargar, instalar o utilizar la aplicación AutoMate ("la Aplicación"), usted acepta estar sujeto a estos Términos y Condiciones de Uso ("Términos"). Si no está de acuerdo con estos términos, no utilice la Aplicación.',
            ),
            
            _buildSection(
              theme,
              '2. Descripción del Servicio',
              'AutoMate es una aplicación móvil diseñada para ayudar a los usuarios a gestionar y rastrear los gastos, mantenimiento y estadísticas relacionadas con sus vehículos. La Aplicación ofrece tanto una versión gratuita con funcionalidades limitadas como una versión premium con características adicionales.',
            ),
            
            _buildSection(
              theme,
              '3. Registro y Cuenta de Usuario',
              'Para utilizar ciertas funciones de la Aplicación, debe crear una cuenta proporcionando información precisa y completa. Usted es responsable de mantener la confidencialidad de sus credenciales de acceso y de todas las actividades que ocurran bajo su cuenta.',
            ),
            
            _buildSection(
              theme,
              '4. Versión Gratuita y Premium',
              'La versión gratuita de AutoMate permite registrar hasta 2 vehículos y incluye funcionalidades básicas con anuncios publicitarios. La versión Premium elimina estas limitaciones, ofrece funciones adicionales y una experiencia sin anuncios mediante suscripción de pago.',
            ),
            
            _buildSection(
              theme,
              '5. Suscripciones y Pagos',
              'Las suscripciones Premium se renuevan automáticamente a menos que se cancelen antes del final del período actual. Los precios están sujetos a cambios con previo aviso. Las suscripciones se gestionan a través de Google Play Store o Apple App Store según corresponda.',
            ),
            
            _buildSection(
              theme,
              '6. Uso Aceptable',
              'Usted se compromete a utilizar la Aplicación únicamente para fines legales y de acuerdo con estos Términos. No debe:\n• Usar la Aplicación para actividades ilegales\n• Intentar acceder no autorizado a los sistemas\n• Interferir con el funcionamiento de la Aplicación\n• Compartir contenido ofensivo o inapropiado',
            ),
            
            _buildSection(
              theme,
              '7. Propiedad Intelectual',
              'Todos los derechos de propiedad intelectual en la Aplicación, incluyendo pero no limitado a software, diseño, contenido y marcas comerciales, pertenecen a AutoMate o sus licenciantes.',
            ),
            
            _buildSection(
              theme,
              '8. Privacidad y Datos',
              'El tratamiento de sus datos personales se rige por nuestra Política de Privacidad, que forma parte integral de estos Términos. Al usar la Aplicación, consiente el tratamiento de sus datos según se describe en dicha política.',
            ),
            
            _buildSection(
              theme,
              '9. Limitación de Responsabilidad',
              'AutoMate se proporciona "tal como está" sin garantías de ningún tipo. No seremos responsables de daños directos, indirectos, incidentales o consecuentes derivados del uso de la Aplicación.',
            ),
            
            _buildSection(
              theme,
              '10. Modificaciones',
              'Nos reservamos el derecho de modificar estos Términos en cualquier momento. Las modificaciones entrarán en vigor inmediatamente tras su publicación en la Aplicación. El uso continuado constituye aceptación de los términos modificados.',
            ),
            
            _buildSection(
              theme,
              '11. Terminación',
              'Podemos suspender o terminar su acceso a la Aplicación en cualquier momento por violación de estos Términos. Usted puede dejar de usar la Aplicación en cualquier momento.',
            ),
            
            _buildSection(
              theme,
              '12. Ley Aplicable',
              'Estos Términos se rigen por las leyes de España. Cualquier disputa será resuelta en los tribunales competentes de España.',
            ),
            
            _buildSection(
              theme,
              '13. Contacto',
              'Para preguntas sobre estos Términos, puede contactarnos en:\n\nEmail: support@automate-app.com\nSitio web: www.automate-app.com',
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
                child: const Text('Acepto los Términos y Condiciones'),
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
