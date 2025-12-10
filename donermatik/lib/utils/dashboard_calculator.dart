import 'package:intl/intl.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import 'package:flutter/material.dart';

class DashboardCalculator {
  // -------------------------------------------------------------
  // 1) AYLIK TOPLAM GELİR
  // -------------------------------------------------------------
  static double monthlyIncome(List<IncomeModel> incomes, DateTime now) {
    return incomes
        .where((i) => i.date.year == now.year && i.date.month == now.month)
        .fold(0.0, (sum, i) => sum + i.amount);
  }

  // -------------------------------------------------------------
  // 2) AYLIK TOPLAM GİDER
  // -------------------------------------------------------------
  static double monthlyExpense(List<ExpenseModel> expenses, DateTime now) {
    return expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  // -------------------------------------------------------------
  // 3) KALAN BÜTÇE
  // -------------------------------------------------------------
  static double remainingBudget(
    List<IncomeModel> incomes,
    List<ExpenseModel> expenses,
    DateTime now,
  ) {
    return monthlyIncome(incomes, now) - monthlyExpense(expenses, now);
  }

  // -------------------------------------------------------------
  // 4) BU AY KAÇ DÖNER YEDİN?
  // döner fiyatı → birim sisteminden alınacak (default döner id = doner)
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
  // 5) AYLIK TREND GRAFİĞİ (1-30 gün arası)
  // Chart için günlük gider listesi döner
  // -------------------------------------------------------------
  static List<double> monthlyTrend(List<ExpenseModel> expenses, DateTime now) {
    List<double> result = [];

    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

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
  // 6) EN ÇOK PARA HARCANAN KATEGORİ
  // {"market": 430, "cafe": 120, ...}
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
  // 7) GEÇEN AY İLE KIYASLAMA
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

    return currentMonth - lastMonth; // pozitif → daha fazla harcamış
  }

  // -------------------------------------------------------------
  // 8) HAFTALIK HARCAMA DAĞILIMI (7 değerlik liste)
  // -------------------------------------------------------------
  static List<double> weeklyDistribution(
    List<ExpenseModel> expenses,
    DateTime now,
  ) {
    List<double> result = List.filled(7, 0);

    for (var e in expenses) {
      final diff = now.difference(e.date).inDays;

      if (diff >= 0 && diff < 7) {
        result[6 - diff] += e.amount;
      }
    }

    return result;
  }
}
