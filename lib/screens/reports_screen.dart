import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../providers/settings_provider.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedDateRange = 'This Month';
  
  final List<String> _dateRanges = [
    'This Week',
    'This Month',
    'Last Month',
    'This Year',
    'All Time',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer2<TransactionProvider, SettingsProvider>(
        builder: (context, txProvider, settings, child) {
          final groupedExpenses = txProvider.groupedExpenses;
          final totalExpense = txProvider.totalExpense;
          final currency = settings.currencySymbol;

          List<PieChartSectionData> pieSections = [];
          if (groupedExpenses.isNotEmpty && totalExpense > 0) {
            groupedExpenses.forEach((category, amount) {
              Color color = Colors.grey;
              if (category == 'Food') { color = Colors.orange; }
              else if (category == 'Transport') { color = Colors.blue; }
              else if (category == 'Utilities') { color = Colors.purple; }
              else if (category == 'Entertainment') { color = Colors.pink; }
              else if (category == 'Shopping') { color = Colors.teal; }

              final percentage = (amount / totalExpense) * 100;
              
              pieSections.add(
                PieChartSectionData(
                  color: color,
                  value: amount,
                  title: '${percentage.toStringAsFixed(1)}%',
                  radius: 50,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                )
              );
            });
          }

          return Column(
            children: [
              // Date Filter Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date Range:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    DropdownButton<String>(
                      value: _selectedDateRange,
                      underline: const SizedBox(),
                      items: _dateRanges.map((String range) {
                        return DropdownMenuItem(
                          value: range,
                          child: Text(range),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedDateRange = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Pie Chart Area
                      Container(
                        height: 250,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: pieSections.isEmpty 
                          ? Center(
                              child: Text(
                                'No data to display',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections: pieSections,
                                  ),
                                ),
                                Text(
                                  'Total\n$currency${totalExpense.toStringAsFixed(2)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Category Breakdown
                      const Text(
                        'Expenses by Category',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      
                      if (groupedExpenses.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: Text('No expenses recorded yet.', style: TextStyle(color: Colors.grey))),
                        )
                      else
                        ...groupedExpenses.entries.map((entry) {
                          final category = entry.key;
                          final amount = entry.value;
                          final percentage = totalExpense > 0 ? amount / totalExpense : 0.0;
                          
                          IconData icon = Icons.category;
                          Color color = Colors.grey;
                          
                          if (category == 'Food') { icon = Icons.restaurant; color = Colors.orange; }
                          else if (category == 'Transport') { icon = Icons.directions_car; color = Colors.blue; }
                          else if (category == 'Utilities') { icon = Icons.power; color = Colors.purple; }
                          else if (category == 'Entertainment') { icon = Icons.movie; color = Colors.pink; }
                          else if (category == 'Shopping') { icon = Icons.shopping_bag; color = Colors.teal; }

                          return _buildCategoryItem(context, category, icon, color, amount, percentage, currency);
                        }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon, Color color, double amount, double percentage, String currency) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('-$currency${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: Theme.of(context).dividerColor,
                  color: color,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
