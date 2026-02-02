class Quest {
  final String id;
  final String title;
  final String description;
  final String reward;
  final String difficulty; // E, D, C, B, A, S
  final bool isCompleted;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.difficulty,
    this.isCompleted = false,
  });

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    String? reward,
    String? difficulty,
    bool? isCompleted,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      difficulty: difficulty ?? this.difficulty,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
