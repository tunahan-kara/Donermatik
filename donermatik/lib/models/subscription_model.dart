class SubscriptionModel {
  final String id;
  final String name;
  final double price; // aylık TL

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
  });

  SubscriptionModel copyWith({String? id, String? name, double? price}) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'price': price};
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }
}
