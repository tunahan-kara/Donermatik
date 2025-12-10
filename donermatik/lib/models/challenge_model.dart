class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final bool completed;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  ChallengeModel copyWith({bool? completed}) {
    return ChallengeModel(
      id: id,
      title: title,
      description: description,
      completed: completed ?? this.completed,
    );
  }
}
