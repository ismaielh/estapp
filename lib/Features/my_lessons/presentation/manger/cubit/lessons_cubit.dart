import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lessons_state.dart';

class Subject {
  final String id;
  final String title;
  final IconData? icon;
  final List<Unit> units;

  const Subject({
    required this.id,
    required this.title,
    this.icon,
    required this.units,
  });

  Subject copyWith({List<Unit>? units}) {
    return Subject(
      id: id,
      title: title,
      icon: icon,
      units: units ?? this.units,
    );
  }
}

class Unit {
  final String id;
  final String title;
  final List<Lesson> lessons;
  final bool isExpanded;

  const Unit({
    required this.id,
    required this.title,
    required this.lessons,
    this.isExpanded = false,
  });

  Unit copyWith({
    String? id,
    String? title,
    List<Lesson>? lessons,
    bool? isExpanded,
  }) {
    return Unit(
      id: id ?? this.id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final bool isActivated;

  const Lesson({
    required this.id,
    required this.title,
    this.isActivated = false,
  });
}

class LessonsCubit extends Cubit<LessonsState> {
  LessonsCubit() : super(const LessonsInitial());

  void loadSubjects() {
    emit(const LessonsLoading());
    try {
      final subjects = [
        Subject(
          id: 'subject1',
          title: 'Mathematics',
          icon: Icons.calculate,
          units: [
            Unit(
              id: 'unit1',
              title: '1',
              lessons: [
                Lesson(id: 'lesson1', title: '1'),
                Lesson(id: 'lesson2', title: '2'),
              ],
            ),
            Unit(
              id: 'unit2',
              title: '2',
              lessons: [
                Lesson(id: 'lesson3', title: '3'),
                Lesson(id: 'lesson4', title: '4'),
              ],
            ),
          ],
        ),
        Subject(
          id: 'subject2',
          title: 'Science',
          icon: Icons.science,
          units: [
            Unit(
              id: 'unit3',
              title: '1',
              lessons: [
                Lesson(id: 'lesson5', title: '5'),
                Lesson(id: 'lesson6', title: '6'),
              ],
            ),
          ],
        ),
      ];
      emit(LessonsLoaded(subjects: subjects));
    } catch (e) {
      emit(LessonsError(message: 'Failed to load subjects: $e'));
    }
  }

  void toggleUnitExpansion(String unitId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      final updatedSubjects = currentState.subjects.map((subject) {
        final updatedUnits = subject.units.map((unit) {
          if (unit.id == unitId) {
            return unit.copyWith(isExpanded: !unit.isExpanded);
          }
          return unit;
        }).toList();
        return subject.copyWith(units: updatedUnits);
      }).toList();
      emit(LessonsLoaded(subjects: updatedSubjects));
    }
  }
}