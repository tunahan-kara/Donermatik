import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../utils/finance_storage.dart';

class QuickAddExpenseScreen extends StatefulWidget {
  final List<CategoryModel> categories;
  final Function(List<ExpenseModel>) onUpdated;

  const QuickAddExpenseScreen({
    super.key,
    required this.categories,
    required this.onUpdated,
  });

  @override
  State<QuickAddExpenseScreen> createState() => _QuickAddExpenseScreenState();
}

class _QuickAddExpenseScreenState extends State<QuickAddExpenseScreen> {
  final TextEditingController amountCtrl = TextEditingController();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hızlı Gider Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tutar (TL)", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 8),

            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Örnek: 80",
                prefixIcon: Icon(Icons.currency_lira),
              ),
            ),

            const SizedBox(height: 22),

            const Text("Kategori", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: widget.categories.map((c) {
                final selected = selectedCategory == c.id;

                return ChoiceChip(
                  label: Text("${c.icon} ${c.name}"),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => selectedCategory = c.id);
                  },
                );
              }).toList(),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final amount = double.tryParse(amountCtrl.text);
    if (amount == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tutar ve kategori gerekli")),
      );
      return;
    }

    final newExpense = ExpenseModel(
      id: const Uuid().v4(),
      name: "Expense",
      amount: amount,
      date: DateTime.now(),
      categoryId: selectedCategory!,
    );

    final expenses = await FinanceStorage.loadExpenses();
    expenses.add(newExpense);

    await FinanceStorage.saveExpenses(expenses);
    widget.onUpdated(expenses);

    Navigator.pop(context);
  }
}
