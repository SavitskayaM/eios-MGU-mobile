// Простые модели данных для студента

class Student {
  final String name;
  final String group;
  final String faculty;
  final String photoUrl;

  Student({
    required this.name,
    required this.group,
    required this.faculty,
    this.photoUrl = '',
  });
}

class Discipline {
  final int id;
  final String name;
  final String teacher;
  final int totalScore;
  final int currentScore;

  Discipline({
    required this.id,
    required this.name,
    required this.teacher,
    required this.totalScore,
    required this.currentScore,
  });

  double get percentage => totalScore > 0 ? (currentScore / totalScore * 100) : 0;
}

class Lesson {
  final String time;
  final String name;
  final String teacher;
  final String room;
  final String type;

  Lesson({
    required this.time,
    required this.name,
    required this.teacher,
    required this.room,
    required this.type,
  });
}
