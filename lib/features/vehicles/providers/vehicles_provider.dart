import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/vehicle_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/firebase_service.dart';

/// Estado de la gestión de vehículos
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

/// Notificador para la gestión de vehículos
class VehiclesNotifier extends StateNotifier<VehiclesState> {
  final FirebaseService _firebaseService;
  final String userId;

  VehiclesNotifier(this._firebaseService, this.userId) : super(const VehiclesState()) {
    loadVehicles();
  }

  /// Carga los vehículos del usuario desde Firebase
  Future<void> loadVehicles() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final vehicles = await _firebaseService.getVehicles(userId);
      state = state.copyWith(
        vehicles: vehicles,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        vehicles: [],
        isLoading: false,
        error: null,
      );
    }
  }


  /// Agrega un nuevo vehículo
  Future<void> addVehicle(VehicleModel vehicle) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final vehicleData = vehicle.copyWith(
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final docRef = await _firebaseService.vehiclesCollection.add(vehicleData.toJson());
      
      final newVehicle = vehicleData.copyWith(id: docRef.id);
      final updatedVehicles = [...state.vehicles, newVehicle];

      // Si es el primer vehículo, seleccionarlo automáticamente
      VehicleModel? selectedVehicle = state.selectedVehicle;
      if (state.vehicles.isEmpty) {
        selectedVehicle = newVehicle;
      }

      state = state.copyWith(
        vehicles: updatedVehicles,
        selectedVehicle: selectedVehicle,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error adding vehicle: $e',
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

      // Actualizar vehículo seleccionado si es el mismo
      VehicleModel? selectedVehicle = state.selectedVehicle;
      if (selectedVehicle?.id == vehicle.id) {
        selectedVehicle = updatedVehicle;
      }

      state = state.copyWith(
        vehicles: updatedVehicles,
        selectedVehicle: selectedVehicle,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error updating vehicle: $e',
      );
    }
  }

  /// Elimina un vehículo
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firebaseService.vehiclesCollection.doc(vehicleId).delete();

      final updatedVehicles = state.vehicles.where((v) => v.id != vehicleId).toList();

      // Si el vehículo eliminado era el seleccionado, seleccionar otro
      VehicleModel? selectedVehicle = state.selectedVehicle;
      if (selectedVehicle?.id == vehicleId) {
        selectedVehicle = updatedVehicles.isNotEmpty ? updatedVehicles.first : null;
      }

      state = state.copyWith(
        vehicles: updatedVehicles,
        selectedVehicle: selectedVehicle,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error deleting vehicle: $e',
      );
    }
  }

  /// Selecciona un vehículo
  void selectVehicle(VehicleModel vehicle) {
    state = state.copyWith(selectedVehicle: vehicle);
  }

  /// Actualiza el kilometraje actual de un vehículo
  Future<void> updateMileage(String vehicleId, double newMileage) async {
    try {
      final vehicle = state.vehicles.firstWhere((v) => v.id == vehicleId);
      final updatedVehicle = vehicle.copyWith(
        currentOdometer: newMileage,
        updatedAt: DateTime.now(),
      );
      
      await updateVehicle(updatedVehicle);
    } catch (e) {
      state = state.copyWith(error: 'Error updating mileage: $e');
    }
  }

  /// Limpia errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider del notificador de vehículos
final vehiclesNotifierProvider = StateNotifierProvider.family<VehiclesNotifier, VehiclesState, String>((ref, userId) {
  final firebaseService = ref.read(firebaseServiceProvider);
  return VehiclesNotifier(firebaseService, userId);
});

/// Provider de la lista de vehículos
final vehiclesListProvider = Provider.family<List<VehicleModel>, String>((ref, userId) {
  return ref.watch(vehiclesNotifierProvider(userId)).vehicles;
});

/// Provider del vehículo seleccionado
final selectedVehicleProvider = Provider.family<VehicleModel?, String>((ref, userId) {
  return ref.watch(vehiclesNotifierProvider(userId)).selectedVehicle;
});

/// Provider que verifica si el usuario puede agregar más vehículos
final canAddVehicleProvider = Provider.family<bool, String>((ref, userId) {
  final vehicles = ref.watch(vehiclesListProvider(userId));
  // En la versión gratuita, máximo 2 vehículos
  // TODO: Verificar tipo de suscripción del usuario
  return vehicles.length < 2;
});
