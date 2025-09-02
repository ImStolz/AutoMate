import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../core/services/preferences_service.dart';

/// Overlay de tutorial interactivo con cuadros flotantes
class TutorialOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final List<TutorialStep> steps;
  final VoidCallback? onComplete;

  const TutorialOverlay({
    super.key,
    required this.child,
    required this.steps,
    this.onComplete,
  });

  @override
  ConsumerState<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends ConsumerState<TutorialOverlay> {
  late List<GlobalKey> _showcaseKeys;

  @override
  void initState() {
    super.initState();
    _showcaseKeys = List.generate(
      widget.steps.length,
      (index) => GlobalKey(),
    );

    // Iniciar tutorial después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!PreferencesService.getTutorialCompleted()) {
        _startTutorial();
      }
    });
  }

  void _startTutorial() {
    ShowCaseWidget.of(context).startShowCase(_showcaseKeys);
  }

  void _onTutorialComplete() {
    PreferencesService.setTutorialCompleted(true);
    widget.onComplete?.call();
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => _buildChildWithShowcases(),
      onStart: (index, key) {
        // Callback cuando inicia un paso
      },
      onComplete: (index, key) {
        if (index == _showcaseKeys.length - 1) {
          _onTutorialComplete();
        }
      },
      blurValue: 1,
      autoPlayDelay: const Duration(seconds: 3),
    );
  }

  Widget _buildChildWithShowcases() {
    Widget result = widget.child;

    // Envolver elementos específicos con Showcase
    for (int i = 0; i < widget.steps.length; i++) {
      final step = widget.steps[i];
      result = _wrapWithShowcase(result, i, step);
    }

    return result;
  }

  Widget _wrapWithShowcase(Widget child, int index, TutorialStep step) {
    return Showcase(
      key: _showcaseKeys[index],
      title: step.title,
      description: step.description,
      targetShapeBorder: step.shapeBorder ?? const CircleBorder(),
      tooltipBackgroundColor: Theme.of(context).colorScheme.primary,
      textColor: Colors.white,
      targetBorderRadius: BorderRadius.circular(12),
      child: child,
    );
  }
}

/// Modelo para los pasos del tutorial
class TutorialStep {
  final String title;
  final String description;
  final ShapeBorder? shapeBorder;
  final String targetKey;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.targetKey,
    this.shapeBorder,
  });
}

/// Widget para mostrar tutorial en dashboard
class DashboardTutorial extends ConsumerWidget {
  final Widget child;

  const DashboardTutorial({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = [
      const TutorialStep(
        title: 'Selector de Vehículos',
        description: 'Aquí puedes cambiar entre tus diferentes vehículos registrados.',
        targetKey: 'vehicle_selector',
      ),
      const TutorialStep(
        title: 'Resumen de Gastos',
        description: 'Ve un resumen rápido de tus gastos mensuales y estadísticas.',
        targetKey: 'expense_summary',
      ),
      const TutorialStep(
        title: 'Acciones Rápidas',
        description: 'Toca este botón para registrar combustible, gastos o mantenimiento rápidamente.',
        targetKey: 'quick_actions',
      ),
      TutorialStep(
        title: 'Navegación',
        description: 'Usa la barra inferior para navegar entre las diferentes secciones de la app.',
        targetKey: 'bottom_navigation',
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ];

    return TutorialOverlay(
      steps: steps,
      onComplete: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Tutorial completado! Ya puedes usar AutoMate.'),
            backgroundColor: Colors.green,
          ),
        );
      },
      child: child,
    );
  }
}

/// Widget para mostrar tutorial en pantalla de vehículos
class VehiclesTutorial extends ConsumerWidget {
  final Widget child;

  const VehiclesTutorial({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final steps = [
      const TutorialStep(
        title: 'Agregar Vehículo',
        description: 'Toca aquí para registrar un nuevo vehículo en tu cuenta.',
        targetKey: 'add_vehicle_button',
      ),
      const TutorialStep(
        title: 'Gestionar Vehículos',
        description: 'Toca en cualquier vehículo para ver detalles, editar o eliminar.',
        targetKey: 'vehicle_card',
      ),
    ];

    return TutorialOverlay(
      steps: steps,
      child: child,
    );
  }
}

/// Provider para controlar el estado del tutorial
final tutorialProvider = StateNotifierProvider<TutorialNotifier, TutorialState>((ref) {
  return TutorialNotifier();
});

class TutorialState {
  final bool isActive;
  final int currentStep;
  final String? currentScreen;

  const TutorialState({
    this.isActive = false,
    this.currentStep = 0,
    this.currentScreen,
  });

  TutorialState copyWith({
    bool? isActive,
    int? currentStep,
    String? currentScreen,
  }) {
    return TutorialState(
      isActive: isActive ?? this.isActive,
      currentStep: currentStep ?? this.currentStep,
      currentScreen: currentScreen ?? this.currentScreen,
    );
  }
}

class TutorialNotifier extends StateNotifier<TutorialState> {
  TutorialNotifier() : super(const TutorialState());

  void startTutorial(String screen) {
    state = state.copyWith(
      isActive: true,
      currentStep: 0,
      currentScreen: screen,
    );
  }

  void nextStep() {
    state = state.copyWith(
      currentStep: state.currentStep + 1,
    );
  }

  void completeTutorial() {
    PreferencesService.setTutorialCompleted(true);
    state = state.copyWith(
      isActive: false,
      currentStep: 0,
      currentScreen: null,
    );
  }

  void skipTutorial() {
    PreferencesService.setTutorialCompleted(true);
    state = state.copyWith(
      isActive: false,
      currentStep: 0,
      currentScreen: null,
    );
  }
}
