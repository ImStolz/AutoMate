import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Widget que muestra un gráfico de barras con los gastos de los últimos meses
class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 400,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.colorScheme.surface,
                      tooltipBorder: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '€${rod.toY.round()}',
                          TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago'
                          ];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                months[value.toInt()],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '€${value.toInt()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _generateSampleData(theme),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 100,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.outline.withOpacity(0.1),
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  context,
                  color: theme.colorScheme.primary,
                  label: 'Combustible',
                ),
                _buildLegendItem(
                  context,
                  color: Colors.orange,
                  label: 'Mantenimiento',
                ),
                _buildLegendItem(
                  context,
                  color: Colors.green,
                  label: 'Otros',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Genera datos de ejemplo para el gráfico
  List<BarChartGroupData> _generateSampleData(ThemeData theme) {
    return [
      _createBarGroup(0, 180, 50, 30, theme),
      _createBarGroup(1, 220, 80, 40, theme),
      _createBarGroup(2, 160, 30, 25, theme),
      _createBarGroup(3, 280, 120, 60, theme),
      _createBarGroup(4, 200, 70, 35, theme),
      _createBarGroup(5, 245, 90, 45, theme),
    ];
  }

  /// Crea un grupo de barras para el gráfico
  BarChartGroupData _createBarGroup(
    int x,
    double fuel,
    double maintenance,
    double others,
    ThemeData theme,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: fuel + maintenance + others,
          color: theme.colorScheme.primary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          rodStackItems: [
            BarChartRodStackItem(0, fuel, theme.colorScheme.primary),
            BarChartRodStackItem(fuel, fuel + maintenance, Colors.orange),
            BarChartRodStackItem(fuel + maintenance, fuel + maintenance + others, Colors.green),
          ],
        ),
      ],
    );
  }

  /// Construye un elemento de la leyenda
  Widget _buildLegendItem(BuildContext context, {
    required Color color,
    required String label,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
