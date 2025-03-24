
import 'package:estapps/Features/my_lessons/data/models/subject.dart';

abstract class LessonsState {}

class LessonsInitial extends LessonsState {
  LessonsInitial();
}

class LessonsLoading extends LessonsState {
  LessonsLoading();
}

class LessonsLoaded extends LessonsState {
  final List<Subject> subjects;

  LessonsLoaded({required this.subjects});
}

class LessonsError extends LessonsState {
  final String message;

  LessonsError({required this.message});
}