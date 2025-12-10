class ExpenseModel {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String categoryId;

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "amount": amount.toString(),
      "date": date.toIso8601String(),
      "categoryId": categoryId,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map["id"],
      name: map["name"],
      amount: double.parse(map["amount"]),
      date: DateTime.parse(map["date"]),
      categoryId: map["categoryId"],
    );
  }
}
