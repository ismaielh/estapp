import 'package:estapps/Features/my_teacher/presentation/models/teacher_models.dart' as teacher;

abstract class TeacherState {}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<teacher.MyGradeLevel> gradeLevels;
  final List<teacher.MySubject> subjects;
  final List<teacher.MyTeacher> teachers;

  TeacherLoaded({
    required this.gradeLevels,
    required this.subjects,
    required this.teachers,
  });
}

class TeacherError extends TeacherState {
  final String message;

  TeacherError({required this.message});
}