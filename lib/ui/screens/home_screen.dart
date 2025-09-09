import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/expense_provider.dart';
import '../widgets/expense_tile.dart';
import 'add_edit_expense_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    final df = DateFormat('MMMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Chi tiêu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ExpenseProvider>().load(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Summary
            Row(
              children: const [
                _SummaryCard(kind: _SumKind.income),
                SizedBox(width: 12),
                _SummaryCard(kind: _SumKind.expense),
                SizedBox(width: 12),
                _SummaryCard(kind: _SumKind.balance),
              ],
            ),
            const SizedBox(height: 16),
            // Month selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    final m = DateTime(p.currentMonth.year, p.currentMonth.month - 1, 1);
                    context.read<ExpenseProvider>().changeMonth(m);
                  },
                ),
                Text(df.format(p.currentMonth),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final m = DateTime(p.currentMonth.year, p.currentMonth.month + 1, 1);
                    context.read<ExpenseProvider>().changeMonth(m);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            // List
            for (final e in p.items)
              ExpenseTile(
                expense: e,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddEditExpenseScreen(initial: e)),
                  );
                },
                onDelete: () => context.read<ExpenseProvider>().remove(e.id!),
              ),
            if (p.items.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: Text('Chưa có giao dịch trong tháng')),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AddEditExpenseScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum _SumKind { income, expense, balance }

class _SummaryCard extends StatelessWidget {
  final _SumKind kind;
  const _SummaryCard({required this.kind});

  String _title() {
    switch (kind) {
      case _SumKind.income: return 'Thu';
      case _SumKind.expense: return 'Chi';
      case _SumKind.balance: return 'Số dư';
    }
  }

  double _value(context) {
    final p = context.watch<ExpenseProvider>();
    switch (kind) {
      case _SumKind.income: return p.totalIncome;
      case _SumKind.expense: return p.totalExpense;
      case _SumKind.balance: return p.balance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = _value(context);
    final money = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value);
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(_title()),
              const SizedBox(height: 6),
              Text(money, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
