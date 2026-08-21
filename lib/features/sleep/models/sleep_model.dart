class SleepModel {
  final String id;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int durationMinutes;
  final DateTime date;

  SleepModel({
    required this.id,
    required this.bedtime,
    required this.wakeTime,
    required this.durationMinutes,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bedtime': bedtime.toIso8601String(),
      'wakeTime': wakeTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'date': date.toIso8601String(),
    };
  }

  factory SleepModel.fromMap(Map<String, dynamic> map) {
    return SleepModel(
      id: map['id'],
      bedtime: DateTime.parse(map['bedtime']),
      wakeTime: DateTime.parse(map['wakeTime']),
      durationMinutes: map['durationMinutes'],
      date: DateTime.parse(map['date']),
    );
  }
}