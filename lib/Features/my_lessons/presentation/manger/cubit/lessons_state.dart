import 'package:equatable/equatable.dart';
import 'lessons_cubit.dart';

abstract class LessonsState extends Equatable {
  const LessonsState();

  @override
  List<Object?> get props => [];
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

  LessonsLoaded copyWith({List<Subject>? subjects}) {
    return LessonsLoaded(
      subjects: subjects ?? this.subjects,
    );
  }

  @override
  List<Object?> get props => [subjects];
}

class LessonsError extends LessonsState {
  final String message;

  const LessonsError({required this.message});

  @override
  List<Object?> get props => [message];
}