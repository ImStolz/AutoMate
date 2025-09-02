import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../services/firebase_service.dart';
import '../models/vehicle_model.dart';
import 'auth_provider.dart';

/// Estado para la gestión de vehículos
class VehiclesState {
  final List<VehicleModel> vehicles;
  final VehicleModel? selectedVehicle;
  final bool isLoading;
  final String? error;

  const VehiclesState({
    this.vehicles = const [],
    this.selectedVehicle,
    this.isLoading = false,
    this.error,
  });

  VehiclesState copyWith({
    List<VehicleModel>? vehicles,
    VehicleModel? selectedVehicle,
    bool? isLoading,
    String? error,
  }) {
    return VehiclesState(
      vehicles: vehicles ?? this.vehicles,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notificador para gestionar los vehículos del usuario
class VehiclesNotifier extends StateNotifier<VehiclesState> {
  final FirebaseService _firebaseService;
  final String? _userId;

  VehiclesNotifier(this._firebaseService, this._userId) : super(const VehiclesState()) {
    if (_userId != null) {
      loadVehicles();
    }
  }

  /// Carga todos los vehículos del usuario
  Future<void> loadVehicles() async {
    if (_userId == null) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final vehicles = await _firebaseService.getVehicles(_userId!);
      
      state = state.copyWith(
        vehicles: vehicles,
        isLoading: false,
        selectedVehicle: vehicles.isNotEmpty ? vehicles.first : null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando vehículos: $e',
      );
    }
  }

  /// Agrega un nuevo vehículo
  Future<void> addVehicle(VehicleModel vehicle) async {
    if (_userId == null) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final vehicleWithId = vehicle.copyWith(
        id: const Uuid().v4(),
        userId: _userId!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebaseService.vehiclesCollection
          .doc(vehicleWithId.id)
          .set(vehicleWithId.toJson());

      final updatedVehicles = [...state.vehicles, vehicleWithId];
      
      state = state.copyWith(
        vehicles: updatedVehicles,
        isLoading: false,
        selectedVehicle: state.selectedVehicle ?? vehicleWithId,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error agregando vehículo: $e',
      );
    }
  }

  /// Actualiza un vehículo existente
  Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final updatedVehicle = vehicle.copyWith(updatedAt: DateTime.now());

      await _firebaseService.vehiclesCollection
          .doc(vehicle.id)
          .update(updatedVehicle.toJson());

      final updatedVehicles = state.vehicles
          .map((v) => v.id == vehicle.id ? updatedVehicle : v)
          .toList();
      
      state = state.copyWith(
        vehicles: updatedVehicles,
        isLoading: false,
        selectedVehicle: state.selectedVehicle?.id == vehicle.id 
            ? updatedVehicle 
            : state.selectedVehicle,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error actualizando vehículo: $e',
      );
    }
  }

  /// Actualiza el odómetro de un vehículo
  Future<void> updateOdometer(String vehicleId, double newOdometer) async {
    final vehicle = state.vehicles.firstWhere((v) => v.id == vehicleId);
    await updateVehicle(vehicle.copyWith(currentOdometer: newOdometer));
  }

  /// Elimina un vehículo (lo marca como inactivo)
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.vehiclesCollection
          .doc(vehicleId)
          .update({'isActive': false, 'updatedAt': DateTime.now().toIso8601String()});

      final updatedVehicles = state.vehicles
          .where((v) => v.id != vehicleId)
          .toList();
      
      state = state.copyWith(
        vehicles: updatedVehicles,
        isLoading: false,
        selectedVehicle: state.selectedVehicle?.id == vehicleId 
            ? (updatedVehicles.isNotEmpty ? updatedVehicles.first : null)
            : state.selectedVehicle,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error eliminando vehículo: $e',
      );
    }
  }

  /// Selecciona un vehículo como activo
  void selectVehicle(VehicleModel vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
  }

  /// Limpia errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para gestionar los vehículos
final vehiclesNotifierProvider = StateNotifierProvider<VehiclesNotifier, VehiclesState>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  final authState = ref.watch(authNotifierProvider);
  return VehiclesNotifier(firebaseService, authState.userModel?.id);
});

/// Provider del vehículo seleccionado
final selectedVehicleProvider = Provider<VehicleModel?>((ref) {
  return ref.watch(vehiclesNotifierProvider).selectedVehicle;
});

/// Provider de la lista de vehículos
final vehiclesListProvider = Provider<List<VehicleModel>>((ref) {
  return ref.watch(vehiclesNotifierProvider).vehicles;
});
