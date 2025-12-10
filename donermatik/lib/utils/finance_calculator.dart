import '../models/expense_model.dart';

class FinanceCalculator {
  static double dailyTotal(List<ExpenseModel> expenses, DateTime day) {
    return expenses
        .where(
          (e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day,
        )
        .fold(0, (a, b) => a + b.amount);
  }

  static double weeklyTotal(List<ExpenseModel> expenses, DateTime now) {
    final start = now.subtract(Duration(days: 7));

    return expenses
        .where((e) => e.date.isAfter(start))
        .fold(0, (a, b) => a + b.amount);
  }

  static double monthlyTotal(List<ExpenseModel> expenses, DateTime now) {
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0, (a, b) => a + b.amount);
  }
}
