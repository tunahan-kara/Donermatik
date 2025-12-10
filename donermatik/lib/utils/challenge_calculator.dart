import '../models/challenge_model.dart';
import '../models/expense_model.dart';

class ChallengeCalculator {
  static ChallengeModel weeklyChallenge(List<ExpenseModel> expenses) {
    double weekTotal = 0;

    final now = DateTime.now();
    for (var e in expenses) {
      if (now.difference(e.date).inDays < 7) {
        weekTotal += e.amount;
      }
    }

    double target = (weekTotal * 0.8);
    target = target < 200 ? 200 : target; // minimum hedef

    return ChallengeModel(
      id: "weekChallenge",
      title: "Bu Haftanın Challenge'ı",
      description:
          "Bu hafta harcaman ${target.toStringAsFixed(0)} TL altında kalmaya çalış.",
      completed: false,
    );
  }
}
