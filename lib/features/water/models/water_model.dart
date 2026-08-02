class WaterModel {
  final double consumed;
  final double goal;

  WaterModel({
    required this.consumed,
    required this.goal,
  });

  Map<String, dynamic> toMap() {
    return {
      "consumed": consumed,
      "goal": goal,
    };
  }

  factory WaterModel.fromMap(Map<String, dynamic> map) {
    return WaterModel(
      consumed: (map["consumed"] ?? 0).toDouble(),
      goal: (map["goal"] ?? 3).toDouble(),
    );
  }
}