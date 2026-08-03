class WorkoutModel {
  final String id;
  final String exerciseName;
  final String muscleGroup;
  final int sets;
  final int reps;
  final double weight;
  final int duration;
  final int caloriesBurned;
  final DateTime date;

  WorkoutModel({
    required this.id,
    required this.exerciseName,
    required this.muscleGroup,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.duration,
    required this.caloriesBurned,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseName': exerciseName,
      'muscleGroup': muscleGroup,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      id: map['id'],
      exerciseName: map['exerciseName'],
      muscleGroup: map['muscleGroup'],
      sets: map['sets'],
      reps: map['reps'],
      weight: (map['weight'] as num).toDouble(),
      duration: map['duration'],
      caloriesBurned: map['caloriesBurned'],
      date: DateTime.parse(map['date']),
    );
  }
}