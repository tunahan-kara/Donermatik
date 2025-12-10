class IncomeModel {
  final String id;
  final String name;
  final double amount;
  final DateTime date;

  IncomeModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "amount": amount.toString(),
      "date": date.toIso8601String(),
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map["id"],
      name: map["name"],
      amount: double.parse(map["amount"]),
      date: DateTime.parse(map["date"]),
    );
  }
}
