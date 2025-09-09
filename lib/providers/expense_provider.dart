import 'package:flutter/foundation.dart';
import '../data/models/expense.dart';
import '../data/repositories/expense_repository.dart';

class ExpenseProvider extends ChangeNotifier {
  final _repo = ExpenseRepository();

  DateTime currentMonth = DateTime.now();
  List<Expense> items = [];
  double totalIncome = 0, totalExpense = 0, balance = 0;
  List<double> dailyExpenseBars = const [];

  Future<void> load() async {
    items = await _repo.byMonth(currentMonth);
    final s = await _repo.monthSummary(currentMonth);
    totalIncome = s['income']!;
    totalExpense = s['expense']!;
    balance = s['balance']!;
    dailyExpenseBars = await _repo.dailyExpenses(currentMonth);
    notifyListeners();
  }

  Future<void> add(Expense e) async { await _repo.insert(e); await load(); }
  Future<void> edit(Expense e) async { await _repo.update(e); await load(); }
  Future<void> remove(int id) async { await _repo.delete(id); await load(); }

  void changeMonth(DateTime m) {
    currentMonth = DateTime(m.year, m.month, 1);
    load();
  }

  Future<String> exportCsv() => _repo.exportCsv(currentMonth);
}
