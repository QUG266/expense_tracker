import 'package:sqflite/sqflite.dart';
import '../db/app_db.dart';
import '../models/expense.dart';
import '../../core/date_utils.dart';

class ExpenseRepository {
  Future<int> insert(Expense e) async {
    final d = await AppDatabase().db;
    return d.insert('expenses', e.toMap());
  }

  Future<int> update(Expense e) async {
    final d = await AppDatabase().db;
    return d.update('expenses', e.toMap(), where: 'id=?', whereArgs: [e.id]);
  }

  Future<int> delete(int id) async {
    final d = await AppDatabase().db;
    return d.delete('expenses', where: 'id=?', whereArgs: [id]);
  }

  Future<List<Expense>> byMonth(DateTime m) async {
    final d = await AppDatabase().db;
    final start = monthStart(m).millisecondsSinceEpoch;
    final end = monthEnd(m).millisecondsSinceEpoch;
    final res = await d.query(
      'expenses',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start, end],
      orderBy: 'date DESC',
    );
    return res.map((e) => Expense.fromMap(e)).toList();
  }

  Future<Map<String, double>> monthSummary(DateTime m) async {
    final list = await byMonth(m);
    double income = 0, expense = 0;
    for (final e in list) {
      if (e.type == ExpenseType.income) income += e.amount;
      else expense += e.amount;
    }
    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
    };
  }

  /// Tổng chi tiêu theo từng ngày trong tháng (mảng length = số ngày).
  Future<List<double>> dailyExpenses(DateTime m) async {
    final list = await byMonth(m);
    final n = daysInMonth(m);
    final arr = List<double>.filled(n, 0);
    for (final e in list) {
      if (e.type == ExpenseType.expense) {
        final dayIdx = e.date.day - 1;
        arr[dayIdx] += e.amount;
      }
    }
    return arr;
  }

  /// (tuỳ chọn) export CSV: trả về nội dung CSV
  Future<String> exportCsv(DateTime m) async {
    final list = await byMonth(m);
    final buf = StringBuffer();
    buf.writeln('id,type,category,amount,note,date');
    for (final e in list) {
      buf.writeln('${e.id ?? ''},'
          '${e.type == ExpenseType.income ? 'income' : 'expense'},'
          '"${e.category.replaceAll('"', '""')}",'
          '${e.amount},'
          '"${(e.note ?? '').replaceAll('"', '""')}",'
          '${e.date.toIso8601String()}');
    }
    return buf.toString();
  }
}
