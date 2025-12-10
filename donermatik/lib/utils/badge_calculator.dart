import '../models/badge_model.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import 'dashboard_calculator.dart';

class BadgeCalculator {
  static List<BadgeModel> evaluateBadges({
    required List<ExpenseModel> expenses,
    required List<CategoryModel> categories,
    required DateTime now,
  }) {
    List<BadgeModel> badges = [];

    final totalMonth = DashboardCalculator.monthlyExpense(expenses, now);

    // --------- Döner Ustası LEVEL 1 ----------
    badges.add(
      BadgeModel(
        id: "doner1",
        name: "Döner Ustası L1",
        emoji: "🍗",
        description: "Bu ay 2000 TL harcadın. Midem yandı aga.",
        achieved: totalMonth >= 2000,
      ),
    );

    // --------- LEVEL 2 ----------
    badges.add(
      BadgeModel(
        id: "doner2",
        name: "Döner Ustası L2",
        emoji: "🔥",
        description: "Bu ay 5000 TL harcadın. Harbiden ustasın.",
        achieved: totalMonth >= 5000,
      ),
    );

    // --------- LEVEL 3 ----------
    badges.add(
      BadgeModel(
        id: "doner3",
        name: "Döner Efsanesi",
        emoji: "👑",
        description: "10.000 TL harcayarak döner krallığına girdin.",
        achieved: totalMonth >= 10000,
      ),
    );

    // --------- Kahve Kölesi ----------
    final cafeTotal =
        DashboardCalculator.categoryTotals(expenses, categories, now)["cafe"] ??
        0;

    badges.add(
      BadgeModel(
        id: "coffee1",
        name: "Kahve Kölesi",
        emoji: "☕",
        description: "Bu ay kahveye 400 TL harcadın.",
        achieved: cafeTotal >= 400,
      ),
    );

    // --------- Market Babası ----------
    final marketTotal =
        DashboardCalculator.categoryTotals(
          expenses,
          categories,
          now,
        )["market"] ??
        0;

    badges.add(
      BadgeModel(
        id: "market1",
        name: "Market Babası",
        emoji: "🛒",
        description: "Market alışverişinde bu ay 1500 TL yedin.",
        achieved: marketTotal >= 1500,
      ),
    );

    return badges;
  }
}
