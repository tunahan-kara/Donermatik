class BadgeModel {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final bool achieved;

  BadgeModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.achieved,
  });

  BadgeModel copyWith({bool? achieved}) {
    return BadgeModel(
      id: id,
      name: name,
      emoji: emoji,
      description: description,
      achieved: achieved ?? this.achieved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "emoji": emoji,
      "description": description,
      "achieved": achieved.toString(),
    };
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    return BadgeModel(
      id: map["id"],
      name: map["name"],
      emoji: map["emoji"],
      description: map["description"],
      achieved: map["achieved"] == "true",
    );
  }
}
