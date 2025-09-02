import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../models/expense_model.dart';
import 'auth_provider.dart';
import 'vehicles_provider.dart';

/// Estado para la gestión de gastos
class ExpensesState {
  final List<ExpenseModel> expenses;
  final bool isLoading;
  final String? error;
  final Map<String, double> monthlyTotals;
  final Map<ExpenseCategory, double> categoryTotals;

  const ExpensesState({
    this.expenses = const [],
    this.isLoading = false,
    this.error,
    this.monthlyTotals = const {},
    this.categoryTotals = const {},
  });

  ExpensesState copyWith({
    List<ExpenseModel>? expenses,
    bool? isLoading,
    String? error,
    Map<String, double>? monthlyTotals,
    Map<ExpenseCategory, double>? categoryTotals,
  }) {
    return ExpensesState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      monthlyTotals: monthlyTotals ?? this.monthlyTotals,
      categoryTotals: categoryTotals ?? this.categoryTotals,
    );
  }
}

/// Notificador para gestionar los gastos
class ExpensesNotifier extends StateNotifier<ExpensesState> {
  final FirebaseService _firebaseService;
  final String? _userId;

  ExpensesNotifier(this._firebaseService, this._userId) : super(const ExpensesState()) {
    if (_userId != null) {
      loadExpenses();
    }
  }

  /// Carga todos los gastos del usuario
  Future<void> loadExpenses({String? vehicleId}) async {
    if (_userId == null) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      Query query = _firebaseService.expensesCollection
          .where('userId', isEqualTo: _userId!)
          .orderBy('date', descending: true);

      if (vehicleId != null) {
        query = query.where('vehicleId', isEqualTo: vehicleId);
      }

      final querySnapshot = await query.get();

      final expenses = querySnapshot.docs
          .map((doc) => ExpenseModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();

      final monthlyTotals = _calculateMonthlyTotals(expenses);
      final categoryTotals = _calculateCategoryTotals(expenses);
      
      state = state.copyWith(
        expenses: expenses,
        isLoading: false,
        monthlyTotals: monthlyTotals,
        categoryTotals: categoryTotals,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error cargando gastos: $e',
      );
    }
  }

  /// Agrega un nuevo gasto
  Future<void> addExpense(ExpenseModel expense) async {
    if (_userId == null) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final expenseWithId = expense.copyWith(
        id: const Uuid().v4(),
        userId: _userId!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebaseService.expensesCollection
          .doc(expenseWithId.id)
          .set(expenseWithId.toJson());

      final updatedExpenses = [expenseWithId, ...state.expenses];
      final monthlyTotals = _calculateMonthlyTotals(updatedExpenses);
      final categoryTotals = _calculateCategoryTotals(updatedExpenses);
      
      state = state.copyWith(
        expenses: updatedExpenses,
        isLoading: false,
        monthlyTotals: monthlyTotals,
        categoryTotals: categoryTotals,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error agregando gasto: $e',
      );
    }
  }

  /// Actualiza un gasto existente
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final updatedExpense = expense.copyWith(updatedAt: DateTime.now());

      await _firebaseService.expensesCollection
          .doc(expense.id)
          .update(updatedExpense.toJson());

      final updatedExpenses = state.expenses
          .map((e) => e.id == expense.id ? updatedExpense : e)
          .toList();

      final monthlyTotals = _calculateMonthlyTotals(updatedExpenses);
      final categoryTotals = _calculateCategoryTotals(updatedExpenses);
      
      state = state.copyWith(
        expenses: updatedExpenses,
        isLoading: false,
        monthlyTotals: monthlyTotals,
        categoryTotals: categoryTotals,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error actualizando gasto: $e',
      );
    }
  }

  /// Elimina un gasto
  Future<void> deleteExpense(String expenseId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _firebaseService.expensesCollection
          .doc(expenseId)
          .delete();

      final updatedExpenses = state.expenses
          .where((e) => e.id != expenseId)
          .toList();

      final monthlyTotals = _calculateMonthlyTotals(updatedExpenses);
      final categoryTotals = _calculateCategoryTotals(updatedExpenses);
      
      state = state.copyWith(
        expenses: updatedExpenses,
        isLoading: false,
        monthlyTotals: monthlyTotals,
        categoryTotals: categoryTotals,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error eliminando gasto: $e',
      );
    }
  }

  /// Obtiene gastos por rango de fechas
  Future<List<ExpenseModel>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String? vehicleId,
  }) async {
    if (_userId == null) return [];

    try {
      Query query = _firebaseService.expensesCollection
          .where('userId', isEqualTo: _userId!)
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true);

      if (vehicleId != null) {
        query = query.where('vehicleId', isEqualTo: vehicleId);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs
          .map((doc) => ExpenseModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo gastos por fecha: $e');
    }
  }

  /// Calcula totales mensuales
  Map<String, double> _calculateMonthlyTotals(List<ExpenseModel> expenses) {
    final totals = <String, double>{};
    
    for (final expense in expenses) {
      final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      totals[monthKey] = (totals[monthKey] ?? 0) + expense.amount;
    }
    
    return totals;
  }

  /// Calcula totales por categoría
  Map<ExpenseCategory, double> _calculateCategoryTotals(List<ExpenseModel> expenses) {
    final totals = <ExpenseCategory, double>{};
    
    for (final expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    
    return totals;
  }

  /// Obtiene estadísticas de combustible
  Map<String, dynamic> getFuelStatistics(String vehicleId) {
    final fuelExpenses = state.expenses
        .where((e) => e.vehicleId == vehicleId && e.isFuelExpense)
        .toList();

    if (fuelExpenses.isEmpty) {
      return {
        'totalSpent': 0.0,
        'totalLiters': 0.0,
        'averagePrice': 0.0,
        'averageConsumption': 0.0,
      };
    }

    final totalSpent = fuelExpenses.fold<double>(0, (sum, e) => sum + e.amount);
    final totalLiters = fuelExpenses.fold<double>(0, (sum, e) => sum + (e.quantity ?? 0));
    final averagePrice = totalLiters > 0 ? totalSpent / totalLiters : 0.0;
    
    final consumptionData = fuelExpenses
        .where((e) => e.fuelEfficiency != null)
        .map((e) => e.fuelEfficiency!)
        .toList();
    
    final averageConsumption = consumptionData.isNotEmpty
        ? consumptionData.reduce((a, b) => a + b) / consumptionData.length
        : 0.0;

    return {
      'totalSpent': totalSpent,
      'totalLiters': totalLiters,
      'averagePrice': averagePrice,
      'averageConsumption': averageConsumption,
    };
  }

  /// Limpia errores
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider para gestionar los gastos
final expensesNotifierProvider = StateNotifierProvider<ExpensesNotifier, ExpensesState>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  final authState = ref.watch(authNotifierProvider);
  return ExpensesNotifier(firebaseService, authState.userModel?.id);
});

/// Provider de gastos filtrados por vehículo seleccionado
final vehicleExpensesProvider = Provider<List<ExpenseModel>>((ref) {
  final expenses = ref.watch(expensesNotifierProvider).expenses;
  final selectedVehicle = ref.watch(selectedVehicleProvider);
  
  if (selectedVehicle == null) return expenses;
  
  return expenses.where((e) => e.vehicleId == selectedVehicle.id).toList();
});

/// Provider de totales mensuales
final monthlyTotalsProvider = Provider<Map<String, double>>((ref) {
  return ref.watch(expensesNotifierProvider).monthlyTotals;
});

/// Provider de totales por categoría
final categoryTotalsProvider = Provider<Map<ExpenseCategory, double>>((ref) {
  return ref.watch(expensesNotifierProvider).categoryTotals;
});
