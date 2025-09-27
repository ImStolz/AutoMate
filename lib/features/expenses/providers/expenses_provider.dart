import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/providers/auth_provider.dart';

/// Estado para la gestión de gastos
class ExpensesState extends Equatable {
  final List<ExpenseModel> expenses;
  final bool isLoading;
  final String? error;
  final Map<ExpenseCategory, double> categoryTotals;
  final double totalAmount;
  final DateTime? selectedMonth;

  const ExpensesState({
    this.expenses = const [],
    this.isLoading = false,
    this.error,
    this.categoryTotals = const {},
    this.totalAmount = 0.0,
    this.selectedMonth,
  });

  ExpensesState copyWith({
    List<ExpenseModel>? expenses,
    bool? isLoading,
    String? error,
    Map<ExpenseCategory, double>? categoryTotals,
    double? totalAmount,
    DateTime? selectedMonth,
  }) {
    return ExpensesState(
      expenses: expenses ?? this.expenses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categoryTotals: categoryTotals ?? this.categoryTotals,
      totalAmount: totalAmount ?? this.totalAmount,
      selectedMonth: selectedMonth ?? this.selectedMonth,
    );
  }

  @override
  List<Object?> get props => [
        expenses,
        isLoading,
        error,
        categoryTotals,
        totalAmount,
        selectedMonth,
      ];
}

/// Notificador para la gestión de gastos
class ExpensesNotifier extends StateNotifier<ExpensesState> {
  final FirebaseService _firebaseService;
  final String userId;

  ExpensesNotifier(this._firebaseService, this.userId) : super(const ExpensesState()) {
    loadExpenses();
  }

  /// Carga los gastos del usuario
  Future<void> loadExpenses({String? vehicleId, DateTime? month}) async {
    state = state.copyWith(isLoading: true, error: null, selectedMonth: month);
    
    try {
      final expenses = await _getExpenses(vehicleId: vehicleId, month: month);
      final categoryTotals = _calculateCategoryTotals(expenses);
      final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
      
      state = state.copyWith(
        expenses: expenses,
        isLoading: false,
        categoryTotals: categoryTotals,
        totalAmount: totalAmount,
      );
    } catch (e) {
      print('Error loading expenses: $e');
      state = state.copyWith(
        expenses: [],
        isLoading: false,
        error: 'Error cargando gastos. Verifica tu conexión y permisos.',
        categoryTotals: {},
        totalAmount: 0.0,
      );
    }
  }

  /// Obtiene gastos desde Firebase o datos de ejemplo
  Future<List<ExpenseModel>> _getExpenses({String? vehicleId, DateTime? month}) async {
    try {
      var query = _firebaseService.expensesCollection
          .where('userId', isEqualTo: userId);
      
      if (vehicleId != null) {
        query = query.where('vehicleId', isEqualTo: vehicleId);
      }
      
      if (month != null) {
        final startOfMonth = DateTime(month.year, month.month, 1);
        final endOfMonth = DateTime(month.year, month.month + 1, 0);
        query = query
            .where('date', isGreaterThanOrEqualTo: startOfMonth)
            .where('date', isLessThanOrEqualTo: endOfMonth);
      }
      
      final querySnapshot = await query
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => ExpenseModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw Exception('Error loading expenses: $e');
    }
  }


  /// Calcula totales por categoría
  Map<ExpenseCategory, double> _calculateCategoryTotals(List<ExpenseModel> expenses) {
    final totals = <ExpenseCategory, double>{};
    
    for (final expense in expenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    
    return totals;
  }

  /// Agrega un nuevo gasto
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final expenseData = expense.copyWith(
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).toJson();

      await _firebaseService.expensesCollection.add(expenseData);
      await loadExpenses(vehicleId: expense.vehicleId);
    } catch (e) {
      print('Error adding expense: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error agregando gasto. Verifica tu conexión y permisos.',
      );
    }
  }

  /// Actualiza un gasto existente
  Future<void> updateExpense(ExpenseModel expense) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final expenseData = expense.copyWith(
        updatedAt: DateTime.now(),
      ).toJson();

      await _firebaseService.expensesCollection
          .doc(expense.id)
          .update(expenseData);
      
      await loadExpenses(vehicleId: expense.vehicleId);
    } catch (e) {
      print('Error updating expense: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error actualizando gasto. Verifica tu conexión y permisos.',
      );
    }
  }

  /// Elimina un gasto
  Future<void> deleteExpense(String expenseId, String vehicleId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _firebaseService.expensesCollection.doc(expenseId).delete();
      await loadExpenses(vehicleId: vehicleId);
    } catch (e) {
      print('Error deleting expense: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Error eliminando gasto. Verifica tu conexión y permisos.',
      );
    }
  }

  /// Filtra gastos por categoría
  void filterByCategory(ExpenseCategory? category) {
    if (category == null) {
      loadExpenses();
      return;
    }
    
    final filteredExpenses = state.expenses
        .where((expense) => expense.category == category)
        .toList();
    
    final categoryTotals = _calculateCategoryTotals(filteredExpenses);
    final totalAmount = filteredExpenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    
    state = state.copyWith(
      expenses: filteredExpenses,
      categoryTotals: categoryTotals,
      totalAmount: totalAmount,
    );
  }
}

/// Provider para gastos por usuario
final expensesNotifierProvider = StateNotifierProvider.family<ExpensesNotifier, ExpensesState, String>(
  (ref, userId) {
    final firebaseService = ref.watch(firebaseServiceProvider);
    return ExpensesNotifier(firebaseService, userId);
  },
);

/// Provider para gastos del usuario actual
final currentUserExpensesProvider = Provider<AsyncValue<ExpensesState>>((ref) {
  final authState = ref.watch(authNotifierProvider);
  
  if (authState.firebaseUser == null) {
    return AsyncValue.error('Usuario no autenticado', StackTrace.current);
  }
  
  return AsyncValue.data(ref.watch(expensesNotifierProvider(authState.firebaseUser!.uid)));
});
