import 'package:flutter/material.dart';
import '../../data/models/expense.dart';
import 'package:intl/intl.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const ExpenseTile({super.key, required this.expense, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(expense.amount);
    final date = DateFormat('dd/MM/yyyy').format(expense.date);
    final isIncome = expense.type == ExpenseType.income;

    return Card(
      child: ListTile(
        leading: Icon(isIncome ? Icons.south_west : Icons.north_east,
            color: isIncome ? Colors.green : Colors.red),
        title: Text('${expense.category} • $money',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${expense.note ?? '—'} • $date'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
