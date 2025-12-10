import 'package:flutter/material.dart';

import '../models/income_model.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';

class DashboardCalculator {
  // -------------------------------------------------------------
  // GÜNLÜK TOPLAM GİDER
  // -------------------------------------------------------------
  static double dailyTotal(List<ExpenseModel> expenses, DateTime day) {
    return expenses
        .where(
          (e) =>
              e.date.year == day.year &&
              e.date.month == day.month &&
              e.date.day == day.day,
        )
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  // -------------------------------------------------------------
  // AYLIK TOPLAM GELİR
  // -------------------------------------------------------------
  static double monthlyIncome(List<IncomeModel> incomes, DateTime now) {
    return incomes
        .where((i) => i.date.year == now.year && i.date.month == now.month)
        .fold(0.0, (sum, i) => sum + i.amount);
  }

  // -------------------------------------------------------------
  // AYLIK TOPLAM GİDER
  // -------------------------------------------------------------
  static double monthlyExpense(List<ExpenseModel> expenses, DateTime now) {
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  // -------------------------------------------------------------
  // KALAN BÜTÇE
  // -------------------------------------------------------------
  static double remainingBudget(
    List<IncomeModel> incomes,
    List<ExpenseModel> expenses,
    DateTime now,
  ) {
    return monthlyIncome(incomes, now) - monthlyExpense(expenses, now);
  }

  // -------------------------------------------------------------
  // BU AY KAÇ DÖNER YEDİN?
  // -------------------------------------------------------------
  static double donerCountThisMonth(
    List<ExpenseModel> expenses,
    DateTime now,
    double donerPrice,
  ) {
    if (donerPrice <= 0) return 0;
    final total = monthlyExpense(expenses, now);
    return total / donerPrice;
  }

  // -------------------------------------------------------------
  // AYLIK TREND (GÜN GÜN GİDER)
  // -------------------------------------------------------------
  static List<double> monthlyTrend(List<ExpenseModel> expenses, DateTime now) {
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    List<double> result = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final total = expenses
          .where(
            (e) =>
                e.date.year == now.year &&
                e.date.month == now.month &&
                e.date.day == day,
          )
          .fold(0.0, (sum, e) => sum + e.amount);
      result.add(total);
    }

    return result;
  }

  // -------------------------------------------------------------
  // KATEGORİ TOPLAMLARI
  // -------------------------------------------------------------
  static Map<String, double> categoryTotals(
    List<ExpenseModel> expenses,
    List<CategoryModel> categories,
    DateTime now,
  ) {
    Map<String, double> totals = {};

    for (var c in categories) {
      final total = expenses
          .where(
            (e) =>
                e.categoryId == c.id &&
                e.date.year == now.year &&
                e.date.month == now.month,
          )
          .fold(0.0, (sum, e) => sum + e.amount);

      totals[c.id] = total;
    }

    return totals;
  }

  static CategoryModel? mostSpentCategory(
    List<ExpenseModel> expenses,
    List<CategoryModel> categories,
    DateTime now,
  ) {
    final totals = categoryTotals(expenses, categories, now);
    if (totals.values.every((v) => v == 0)) return null;

    final topId = totals.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    return categories.firstWhere((c) => c.id == topId);
  }

  // -------------------------------------------------------------
  // GEÇEN AY İLE KIYASLAMA
  // -------------------------------------------------------------
  static double compareWithLastMonth(
    List<ExpenseModel> expenses,
    DateTime now,
  ) {
    final currentMonth = monthlyExpense(expenses, now);

    final lastMonthDate = DateTime(
      now.month == 1 ? now.year - 1 : now.year,
      now.month == 1 ? 12 : now.month - 1,
    );

    final lastMonth = monthlyExpense(expenses, lastMonthDate);

    return currentMonth - lastMonth; // pozitif → bu ay daha fazla
  }

  // -------------------------------------------------------------
  // HAFTALIK HARCAMA DAĞILIMI (SON 7 GÜN)
  // -------------------------------------------------------------
  static List<double> weeklyDistribution(
    List<ExpenseModel> expenses,
    DateTime now,
  ) {
    List<double> result = List.filled(7, 0.0);

    for (var e in expenses) {
      final diff = now.difference(e.date).inDays;

      if (diff >= 0 && diff < 7) {
        // 0 = bugün, 6 = 6 gün önce
        result[6 - diff] += e.amount;
      }
    }

    return result;
  }
}
