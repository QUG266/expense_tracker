import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/expense_provider.dart';
import '../../../data/models/expense.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final Expense? initial;
  const AddEditExpenseScreen({super.key, this.initial});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late ExpenseType _type;
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      _type = widget.initial!.type;
      _categoryCtrl.text = widget.initial!.category;
      _amountCtrl.text = widget.initial!.amount.toString();
      _noteCtrl.text = widget.initial!.note ?? '';
      _date = widget.initial!.date;
    } else {
      _type = ExpenseType.expense;
    }
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initial != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Sửa giao dịch' : 'Thêm giao dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField(
                value: _type,
                items: const [
                  DropdownMenuItem(value: ExpenseType.income, child: Text('Thu')),
                  DropdownMenuItem(value: ExpenseType.expense, child: Text('Chi')),
                ],
                onChanged: (v) => setState(() => _type = v!),
                decoration: const InputDecoration(labelText: 'Loại'),
              ),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(labelText: 'Danh mục (VD: Ăn uống)'),
                validator: (v) => (v == null || v.isEmpty) ? 'Nhập danh mục' : null,
              ),
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền'),
                validator: (v) => (v == null || double.tryParse(v) == null)
                    ? 'Số tiền không hợp lệ'
                    : null,
              ),
              TextFormField(
                controller: _noteCtrl,
                decoration: const InputDecoration(labelText: 'Ghi chú (tuỳ chọn)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final data = Expense(
                    id: widget.initial?.id,
                    type: _type,
                    category: _categoryCtrl.text.trim(),
                    amount: double.parse(_amountCtrl.text),
                    note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
                    date: _date,
                  );
                  final p = context.read<ExpenseProvider>();
                  if (isEdit) {
                    await p.edit(data);
                  } else {
                    await p.add(data);
                  }
                  if (mounted) Navigator.pop(context);
                },
                child: Text(isEdit ? 'Lưu thay đổi' : 'Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
