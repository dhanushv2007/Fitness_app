class UserProfile {
  final String uid;
  final String name;
  final String email;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String goal;
  final String activityLevel;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.goal,
    required this.activityLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'goal': goal,
      'activityLevel': activityLevel,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      gender: map['gender'],
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      goal: map['goal'],
      activityLevel: map['activityLevel'],
    );
  }
}