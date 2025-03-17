class MyTeacher {
  final String id;
  final String name;
  final String subjectId;
  final List<MySession> sessions;

  MyTeacher({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.sessions,
  });

  MyTeacher copyWith({
    String? id,
    String? name,
    String? subjectId,
    List<MySession>? sessions,
  }) {
    return MyTeacher(
      id: id ?? this.id,
      name: name ?? this.name,
      subjectId: subjectId ?? this.subjectId,
      sessions: sessions ?? this.sessions,
    );
  }
}

class MyGradeLevel {
  final String id;
  final String title;

  MyGradeLevel({required this.id, required this.title});
}

class MySubject {
  final String id;
  final String title;
  final String gradeLevelId;

  MySubject({required this.id, required this.title, required this.gradeLevelId});
}

class MySession {
  final String id;
  final String teacherId;
  final DateTime date;
  final Duration duration;
  final double price;
  final bool isBooked;

  MySession({
    required this.id,
    required this.teacherId,
    required this.date,
    required this.duration,
    required this.price,
    this.isBooked = false,
  });

  MySession copyWith({
    String? id,
    String? teacherId,
    DateTime? date,
    Duration? duration,
    double? price,
    bool? isBooked,
  }) {
    return MySession(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}