import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/expense_model.dart';

/// Widget de gráfico circular para mostrar distribución de gastos por categoría
class ExpenseChart extends StatefulWidget {
  final Map<ExpenseCategory, double> categoryTotals;
  final double totalAmount;

  const ExpenseChart({
    super.key,
    required this.categoryTotals,
    required this.totalAmount,
  });

  @override
  State<ExpenseChart> createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (widget.categoryTotals.isEmpty || widget.totalAmount <= 0) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('No hay datos para mostrar'),
        ),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _generateSections(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _buildLegend(theme),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    final sections = <PieChartSectionData>[];
    int index = 0;
    
    for (final entry in widget.categoryTotals.entries) {
      final percentage = (entry.value / widget.totalAmount) * 100;
      final isTouch = index == touchedIndex;
      
      sections.add(
        PieChartSectionData(
          color: _getCategoryColor(entry.key),
          value: entry.value,
          title: isTouch ? '${percentage.toStringAsFixed(1)}%' : '',
          radius: isTouch ? 70 : 60,
          titleStyle: TextStyle(
            fontSize: isTouch ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    }
    
    return sections;
  }

  Widget _buildLegend(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.categoryTotals.entries.map((entry) {
        final percentage = (entry.value / widget.totalAmount) * 100;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCategoryName(entry.key),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '€${entry.value.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
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
}
