import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _i = AppDatabase._();
  AppDatabase._();
  factory AppDatabase() => _i;

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    final p = join(await getDatabasesPath(), 'expense_tracker.db');
    _db = await openDatabase(
      p,
      version: 1,
      onCreate: (d, v) async {
        await d.execute('''
          CREATE TABLE expenses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,           -- 'income' | 'expense'
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            note TEXT,
            date INTEGER NOT NULL         -- epoch millis
          )
        ''');
        // (tuỳ chọn) seed vài dòng demo:
        await d.insert('expenses', {
          'type': 'income', 'category': 'Lương', 'amount': 15000000,
          'note': 'Tháng này', 'date': DateTime.now().millisecondsSinceEpoch
        });
        await d.insert('expenses', {
          'type': 'expense', 'category': 'Ăn uống', 'amount': 120000,
          'note': 'Trưa', 'date': DateTime.now().millisecondsSinceEpoch
        });
      },
    );
    return _db!;
  }
}
