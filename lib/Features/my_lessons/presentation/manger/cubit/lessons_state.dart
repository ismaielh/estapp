import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';

abstract class LessonsState {
  const LessonsState();
}

class LessonsInitial extends LessonsState {
  const LessonsInitial();
}

class LessonsLoading extends LessonsState {
  const LessonsLoading();
}

class LessonsLoaded extends LessonsState {
  final List<Subject> subjects;

  const LessonsLoaded({required this.subjects});
}

class LessonsError extends LessonsState {
  final String message;

  const LessonsError({required this.message});
}