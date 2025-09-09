import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/expense_provider.dart';
import '../widgets/monthly_bar_chart.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    final df = DateFormat('MMMM yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Thống kê')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(df.format(p.currentMonth),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Biểu đồ chi theo ngày'),
                  const SizedBox(height: 8),
                  MonthlyBarChart(dailyExpenses: p.dailyExpenseBars),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _RowStat(label: 'Tổng thu', value: p.totalIncome),
                  _RowStat(label: 'Tổng chi', value: p.totalExpense),
                  const Divider(),
                  _RowStat(label: 'Số dư', value: p.balance, bold: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final csv = await context.read<ExpenseProvider>().exportCsv();
              // Lưu file CSV ở thư mục app-documents (demo nhanh)
              // Bạn có thể thêm file_picker/share để chia sẻ ra ngoài
              // Ở đây chỉ in ra console:
              // ignore: avoid_print
              print(csv);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xuất CSV (xem log console)')),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Xuất CSV (demo)'),
          ),
        ],
      ),
    );
  }
}

class _RowStat extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  const _RowStat({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final money =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value);
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(money, style: style)],
      ),
    );
  }
}
