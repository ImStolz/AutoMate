import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/providers/expenses_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/vehicles_provider.dart';
import '../../vehicles/widgets/vehicle_selector.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_chart.dart';
import '../widgets/add_expense_dialog.dart';

/// Pantalla de gestión de gastos con gráficos funcionales
class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ExpenseCategory? _selectedCategory;
  DateTime _selectedMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    
    if (authState.userModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final expensesState = ref.watch(expensesNotifierProvider);
    final vehiclesState = ref.watch(vehiclesNotifierProvider);

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: const Text('Gastos'),
            actions: [
              const VehicleSelector(),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                onPressed: () => _showMonthPicker(context, ref, authState.userModel!.id),
              ),
              PopupMenuButton<ExpenseCategory?>(
                icon: const Icon(Icons.filter_list),
                onSelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  // TODO: Implementar filtro por categoría
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: null,
                    child: Text('Todas las categorías'),
                  ),
                  ...ExpenseCategory.values.map((category) => PopupMenuItem(
                    value: category,
                    child: Text(_getCategoryName(category)),
                  )),
                ],
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'Lista'),
                Tab(icon: Icon(Icons.pie_chart), text: 'Gráficos'),
                Tab(icon: Icon(Icons.analytics), text: 'Análisis'),
              ],
            ),
          ),
          body: expensesState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : expensesState.error != null
                  ? _buildErrorState(theme, expensesState.error!)
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildExpensesList(expensesState, theme, authState.userModel!.id),
                        _buildChartsTab(expensesState, theme),
                        _buildAnalysisTab(expensesState, theme),
                      ],
                    ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddExpenseDialog(context, ref, authState.userModel!.id, vehiclesState),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Gasto'),
          ),
        );
  }

  Widget _buildErrorState(ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              size: 80,
              color: theme.colorScheme.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Error al cargar gastos',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesList(ExpensesState expensesState, ThemeData theme, String userId) {
    if (expensesState.expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              Text(
                'No hay gastos registrados',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Agrega tu primer gasto para comenzar a hacer seguimiento',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Resumen de gastos
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Total del Mes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '€${_calculateTotalAmount(expensesState.expenses).toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
              ),
              Column(
                children: [
                  Text(
                    'Gastos',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${expensesState.expenses.length}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Lista de gastos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: expensesState.expenses.length,
            itemBuilder: (context, index) {
              final expense = expensesState.expenses[index];
              return ExpenseCard(
                expense: expense,
                onTap: () => _showExpenseDetails(context, expense),
                onEdit: () => _editExpense(context, ref, userId, expense),
                onDelete: () => _deleteExpense(context, ref, userId, expense),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChartsTab(ExpensesState expensesState, ThemeData theme) {
    if (expensesState.expenses.isEmpty) {
      return const Center(
        child: Text('No hay datos para mostrar gráficos'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución por Categorías',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ExpenseChart(
            categoryTotals: expensesState.categoryTotals,
            totalAmount: _calculateTotalAmount(expensesState.expenses),
          ),
          const SizedBox(height: 32),
          Text(
            'Gastos por Categoría',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...expensesState.categoryTotals.entries.map((entry) {
            final percentage = (entry.value / _calculateTotalAmount(expensesState.expenses) * 100);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getCategoryName(entry.key),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '€${entry.value.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab(ExpensesState expensesState, ThemeData theme) {
    if (expensesState.expenses.isEmpty) {
      return const Center(
        child: Text('No hay datos para análisis'),
      );
    }

    final fuelExpenses = expensesState.expenses
        .where((e) => e.category == ExpenseCategory.fuel)
        .toList();
    
    final avgFuelCost = fuelExpenses.isNotEmpty
        ? fuelExpenses.fold<double>(0, (sum, e) => sum + e.amount) / fuelExpenses.length
        : 0.0;

    final totalFuelQuantity = fuelExpenses
        .where((e) => e.quantity != null)
        .fold<double>(0, (sum, e) => sum + (e.quantity ?? 0));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Análisis de Gastos',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildAnalysisCard(
            theme,
            'Gasto Promedio por Repostaje',
            '€${avgFuelCost.toStringAsFixed(2)}',
            Icons.local_gas_station,
            theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          _buildAnalysisCard(
            theme,
            'Total Combustible',
            '${totalFuelQuantity.toStringAsFixed(1)} L',
            Icons.opacity,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildAnalysisCard(
            theme,
            'Categoría Más Costosa',
            _getMostExpensiveCategory(expensesState.categoryTotals),
            Icons.trending_up,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildAnalysisCard(
            theme,
            'Promedio Mensual',
            '€${(_calculateTotalAmount(expensesState.expenses)).toStringAsFixed(2)}',
            Icons.calendar_month,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(
    ThemeData theme,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getMostExpensiveCategory(Map<ExpenseCategory, double> categoryTotals) {
    if (categoryTotals.isEmpty) return 'N/A';
    
    final maxEntry = categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return _getCategoryName(maxEntry.key);
  }

  String _getCategoryName(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return 'Combustible';
      case ExpenseCategory.maintenance:
        return 'Mantenimiento';
      case ExpenseCategory.repairs:
        return 'Reparaciones';
      case ExpenseCategory.insurance:
        return 'Seguro';
      case ExpenseCategory.registration:
        return 'Registro';
      case ExpenseCategory.parking:
        return 'Estacionamiento';
      case ExpenseCategory.tolls:
        return 'Peajes';
      case ExpenseCategory.accessories:
        return 'Accesorios';
      case ExpenseCategory.cleaning:
        return 'Limpieza';
      case ExpenseCategory.other:
        return 'Otros';
    }
  }

  Color _getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.fuel:
        return Colors.red;
      case ExpenseCategory.maintenance:
        return Colors.blue;
      case ExpenseCategory.repairs:
        return Colors.orange;
      case ExpenseCategory.insurance:
        return Colors.green;
      case ExpenseCategory.registration:
        return Colors.purple;
      case ExpenseCategory.parking:
        return Colors.teal;
      case ExpenseCategory.tolls:
        return Colors.brown;
      case ExpenseCategory.accessories:
        return Colors.pink;
      case ExpenseCategory.cleaning:
        return Colors.cyan;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }

  void _showMonthPicker(BuildContext context, WidgetRef ref, String userId) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (selectedDate != null) {
      setState(() {
        _selectedMonth = selectedDate;
      });
      ref.read(expensesNotifierProvider.notifier)
          .loadExpenses();
    }
  }

  void _showAddExpenseDialog(BuildContext context, WidgetRef ref, String userId, vehiclesState) {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        userId: userId,
        vehicles: vehiclesState.vehicles,
        onExpenseAdded: (expense) {
          ref.read(expensesNotifierProvider.notifier)
              .addExpense(expense);
        },
      ),
    );
  }

  void _showExpenseDetails(BuildContext context, ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.description),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Categoría', expense.category.name),
              _buildDetailRow('Monto', '\$${expense.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Fecha', expense.date.toString().split(' ')[0]),
              _buildDetailRow('Moneda', expense.currency),
              if (expense.notes != null && expense.notes!.isNotEmpty)
                _buildDetailRow('Notas', expense.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editExpense(context, ref, expense.userId, expense);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _editExpense(BuildContext context, WidgetRef ref, String userId, ExpenseModel expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Gasto'),
        content: const Text('La función de edición de gastos estará disponible próximamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  double _calculateTotalAmount(List<ExpenseModel> expenses) {
    return expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  void _deleteExpense(BuildContext context, WidgetRef ref, String userId, ExpenseModel expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Gasto'),
        content: Text('¿Estás seguro de que quieres eliminar "${expense.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(expensesNotifierProvider.notifier)
          .deleteExpense(expense.id);
    }
  }
}
