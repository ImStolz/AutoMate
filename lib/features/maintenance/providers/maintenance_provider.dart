import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/maintenance_model.dart';
import '../../../core/providers/auth_provider.dart';

// Provider for maintenance stream
final maintenanceStreamProvider = StreamProvider.autoDispose<List<MaintenanceModel>>((ref) {
  final userId = ref.watch(authNotifierProvider).firebaseUser?.uid;
  
  if (userId == null) {
    return const Stream.empty();
  }
  
  final firebaseService = ref.watch(firebaseServiceProvider);
  
  return firebaseService.maintenanceCollection
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => MaintenanceModel.fromFirestore(doc))
          .toList());
});

// Provider for maintenance operations
class MaintenanceNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  
  MaintenanceNotifier(this._ref) : super(const AsyncValue.data(null));
  
  // Add a new maintenance record
  Future<void> addMaintenance(MaintenanceModel maintenance) async {
    try {
      state = const AsyncValue.loading();
      final firebaseService = _ref.read(firebaseServiceProvider);
      
      await firebaseService.maintenanceCollection.add(maintenance.toMap());
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  // Update an existing maintenance record
  Future<void> updateMaintenance(MaintenanceModel maintenance) async {
    try {
      state = const AsyncValue.loading();
      final firebaseService = _ref.read(firebaseServiceProvider);
      
      await firebaseService.maintenanceCollection
          .doc(maintenance.id)
          .update(maintenance.toMap());
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  // Delete a maintenance record
  Future<void> deleteMaintenance(String maintenanceId) async {
    try {
      state = const AsyncValue.loading();
      final firebaseService = _ref.read(firebaseServiceProvider);
      
      await firebaseService.maintenanceCollection.doc(maintenanceId).delete();
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
  
  // Mark maintenance as completed
  Future<void> completeMaintenance(String maintenanceId, {
    required double cost,
    required int odometer,
    String? notes,
    String? receiptUrl,
  }) async {
    try {
      state = const AsyncValue.loading();
      final firebaseService = _ref.read(firebaseServiceProvider);
      
      await firebaseService.maintenanceCollection.doc(maintenanceId).update({
        'completedDate': FieldValue.serverTimestamp(),
        'cost': cost,
        'odometer': odometer,
        if (notes != null) 'notes': notes,
        if (receiptUrl != null) 'receiptUrl': receiptUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

// Provider for maintenance notifier
final maintenanceProvider = StateNotifierProvider.autoDispose<MaintenanceNotifier, AsyncValue<void>>((ref) {
  return MaintenanceNotifier(ref);
});
