class Course {
  final String id;
  final String name;
  final String code;
  final String instructor;
  final String userId;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.instructor,
    required this.userId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      instructor: json['instructor'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'instructor': instructor,
      'user_id': userId,
    };
  }

  Map<String, dynamic> toMap() => toJson();
  
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      instructor: map['instructor'],
      userId: map['user_id'],
    );
  }
}