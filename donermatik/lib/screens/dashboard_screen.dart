import 'package:flutter/material.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';

import '../utils/dashboard_calculator.dart';
import '../utils/finance_storage.dart';
import '../utils/feedback_generator.dart';
import '../theme/app_theme.dart';

import 'quick_add_expense.dart';

class DashboardScreen extends StatefulWidget {
  final List<IncomeModel> incomes;
  final List<ExpenseModel> expenses;
  final List<CategoryModel> categories;
  final double donerPrice;

  const DashboardScreen({
    super.key,
    required this.incomes,
    required this.expenses,
    required this.categories,
    required this.donerPrice,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final monthlyIncome = DashboardCalculator.monthlyIncome(
      widget.incomes,
      now,
    );

    final monthlyExpense = DashboardCalculator.monthlyExpense(
      widget.expenses,
      now,
    );

    final remaining = DashboardCalculator.remainingBudget(
      widget.incomes,
      widget.expenses,
      now,
    );

    final donerCount = DashboardCalculator.donerCountThisMonth(
      widget.expenses,
      now,
      widget.donerPrice,
    );

    final todayExpense = DashboardCalculator.dailyTotal(widget.expenses, now);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dönermatik"),
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------------------------------
            // KALAN BÜTÇE KARTI
            // ------------------------------
            Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(soft: true),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kalan Bütçe",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${remaining.toStringAsFixed(2)} TL",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ------------------------------
            // BUGÜN HARCADIĞIN
            // ------------------------------
            Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Bugün Harcama: ${todayExpense.toStringAsFixed(2)} TL",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ------------------------------
            // BU AY KAÇ DÖNER YEDİN?
            // ------------------------------
            Container(
              width: double.infinity,
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Bu ay kaç döner yedin?",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    donerCount.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text("🔥 Afiyet bal şeker olsun moruk"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ------------------------------
            // MİNİ GRAFİK (placeholder)
            // ------------------------------
            Container(
              width: double.infinity,
              height: 120,
              decoration: AppTheme.cardDecoration(),
              padding: const EdgeInsets.all(14),
              child: const Center(
                child: Text(
                  "Trend Grafiği Buraya Gelecek",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ------------------------------
            // QUICK ADD BUTONLARI
            // ------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _quickButton(
                  icon: Icons.add_circle,
                  text: "Gider",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuickAddExpenseScreen(
                          categories: widget.categories,
                          onUpdated: (data) {
                            setState(() => widget.expenses.clear());
                            setState(() => widget.expenses.addAll(data));
                          },
                        ),
                      ),
                    );
                  },
                ),
                _quickButton(icon: Icons.add_card, text: "Gelir", onTap: () {}),
                _quickButton(
                  icon: Icons.subscriptions,
                  text: "Abonelik",
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ------------------------------
            // TASKBAR REDESIGN (placeholder)
            // ------------------------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppTheme.cardDecoration(),
              child: const Center(
                child: Text(
                  "Taskbar Redesign — Next Update",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        height: 70,
        decoration: AppTheme.cardDecoration(),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accent, size: 28),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
