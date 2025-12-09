class SubscriptionModel {
  final String id;
  final String name;
  final double price; // monthly price in TL
  final String icon; // emoji or icon string

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
  });

  SubscriptionModel copyWith({
    String? id,
    String? name,
    double? price,
    String? icon,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name, "price": price.toString(), "icon": icon};
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map["id"] as String,
      name: map["name"] as String,
      price: double.parse(map["price"].toString()),
      icon: map["icon"] as String,
    );
  }
}
