enum ExpenseType { income, expense }

class Expense {
  final int? id;
  final ExpenseType type;
  final String category;
  final double amount;
  final String? note;
  final DateTime date;

  Expense({
    this.id,
    required this.type,
    required this.category,
    required this.amount,
    this.note,
    required this.date,
  });

  factory Expense.fromMap(Map<String, dynamic> m) => Expense(
        id: m['id'] as int?,
        type: (m['type'] == 'income') ? ExpenseType.income : ExpenseType.expense,
        category: m['category'] as String,
        amount: (m['amount'] as num).toDouble(),
        note: m['note'] as String?,
        date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type == ExpenseType.income ? 'income' : 'expense',
        'category': category,
        'amount': amount,
        'note': note,
        'date': date.millisecondsSinceEpoch,
      };

  Expense copyWith({
    int? id,
    ExpenseType? type,
    String? category,
    double? amount,
    String? note,
    DateTime? date,
  }) =>
      Expense(
        id: id ?? this.id,
        type: type ?? this.type,
        category: category ?? this.category,
        amount: amount ?? this.amount,
        note: note ?? this.note,
        date: date ?? this.date,
      );
}
