class UnitModel {
  final String id;
  final String name;
  final double price; // 1 birim kaç TL?
  final String icon; // emoji veya icon key
  final bool isActive;

  UnitModel({
    required this.id,
    required this.name,
    required this.price,
    required this.icon,
    this.isActive = true,
  });

  UnitModel copyWith({
    String? id,
    String? name,
    double? price,
    String? icon,
    bool? isActive,
  }) {
    return UnitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'icon': icon,
      'isActive': isActive,
    };
  }

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: map['id'] as String,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      icon: map['icon'] as String,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
