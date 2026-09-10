class GameModel {
  final String id;
  final String title;
  final int rewardPoints;

  GameModel({
    required this.id,
    required this.title,
    required this.rewardPoints,
  });

  factory GameModel.fromMap(Map<String, dynamic> map, String documentId) {
    return GameModel(
      id: documentId,
      title: map['title'] ?? '',
      rewardPoints: map['rewardPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'rewardPoints': rewardPoints,
    };
  }
}
