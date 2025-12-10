import 'package:shared_preferences/shared_preferences.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';
import 'dart:convert';

class FinanceStorage {
  static const String incomeKey = "incomes_list";
  static const String expenseKey = "expenses_list";

  // -------------------- INCOME --------------------

  static Future<List<IncomeModel>> loadIncomes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(incomeKey) ?? [];
    return data.map((e) => IncomeModel.fromMap(jsonDecode(e))).toList();
  }

  static Future<void> saveIncomes(List<IncomeModel> incomes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = incomes.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(incomeKey, encoded);
  }

  // -------------------- EXPENSE --------------------

  static Future<List<ExpenseModel>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(expenseKey) ?? [];
    return data.map((e) => ExpenseModel.fromMap(jsonDecode(e))).toList();
  }

  static Future<void> saveExpenses(List<ExpenseModel> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = expenses.map((e) => jsonEncode(e.toMap())).toList();
    await prefs.setStringList(expenseKey, encoded);
  }
}
