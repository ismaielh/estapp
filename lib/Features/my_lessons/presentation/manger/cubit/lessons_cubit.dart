import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lessons_state.dart';
import 'dart:developer' as developer;

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
  final bool isActivated;

  const Unit({
    required this.id,
    required this.title,
    required this.lessons,
    this.isActivated = false,
  });

  Unit copyWith({
    String? id,
    String? title,
    List<Lesson>? lessons,
    bool? isActivated,
  }) {
    return Unit(
      id: id ?? this.id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
      isActivated: isActivated ?? this.isActivated,
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final List<Section> sections;
  final bool isActivated;

  const Lesson({
    required this.id,
    required this.title,
    required this.sections,
    this.isActivated = false,
  });

  Lesson copyWith({
    String? id,
    String? title,
    List<Section>? sections,
    bool? isActivated,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      sections: sections ?? this.sections,
      isActivated: isActivated ?? this.isActivated,
    );
  }
}

class Section {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isActivated;

  const Section({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isActivated = false,
  });

  Section copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isActivated,
  }) {
    return Section(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isActivated: isActivated ?? this.isActivated,
    );
  }
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
                Lesson(
                  id: 'lesson1',
                  title: '1',
                  sections: [
                    Section(id: 'sec1', title: 'Introduction'),
                    Section(id: 'sec2', title: 'Main Content'),
                  ],
                  isActivated: true,
                ),
                Lesson(id: 'lesson2', title: '2', sections: [
                  Section(id: 'sec1', title: 'Introduction'),
                  Section(id: 'sec2', title: 'Main Content'),
                ]),
              ],
              isActivated: false,
            ),
            Unit(
              id: 'unit2',
              title: '2',
              lessons: [
                Lesson(id: 'lesson3', title: '3', sections: [
                  Section(id: 'sec1', title: 'Introduction'),
                  Section(id: 'sec2', title: 'Main Content'),
                ]),
                Lesson(id: 'lesson4', title: '4', sections: [
                  Section(id: 'sec1', title: 'Introduction'),
                  Section(id: 'sec2', title: 'Main Content'),
                ]),
              ],
              isActivated: false,
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
                Lesson(id: 'lesson5', title: '5', sections: [
                  Section(id: 'sec1', title: 'Introduction'),
                  Section(id: 'sec2', title: 'Main Content'),
                ]),
                Lesson(id: 'lesson6', title: '6', sections: [
                  Section(id: 'sec1', title: 'Introduction'),
                  Section(id: 'sec2', title: 'Main Content'),
                ]),
              ],
              isActivated: false,
            ),
          ],
        ),
      ];
      if (subjects.isEmpty) {
        developer.log('LessonsCubit: No subjects loaded');
        emit(const LessonsError(message: 'No subjects available'));
        return;
      }
      for (var subject in subjects) {
        if (subject.units.isEmpty) {
          developer.log('LessonsCubit: Subject ${subject.title} has no units');
        }
        for (var unit in subject.units) {
          if (unit.lessons.isEmpty) {
            developer.log('LessonsCubit: Unit ${unit.title} in ${subject.title} has no lessons');
          }
        }
      }
      developer.log('LessonsCubit: Subjects loaded: ${subjects.length}');
      emit(LessonsLoaded(subjects: subjects));
    } catch (e) {
      developer.log('LessonsCubit: Failed to load subjects: $e');
      emit(LessonsError(message: 'Failed to load subjects: $e'));
    }
  }

  void activateUnit(String unitId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      try {
        final updatedSubjects = currentState.subjects.map((subject) {
          final updatedUnits = subject.units.map((unit) {
            if (unit.id == unitId) {
              if (unit.lessons.isEmpty) {
                developer.log('LessonsCubit: Unit $unitId has no lessons, cannot activate');
                return unit; // لا نفعّل إذا كانت الدروس فارغة
              }
              developer.log('LessonsCubit: Activating unit: ${unit.id}');
              return unit.copyWith(isActivated: true);
            }
            return unit;
          }).toList();
          return subject.copyWith(units: updatedUnits);
        }).toList();
        emit(LessonsLoaded(subjects: updatedSubjects));
      } catch (e) {
        developer.log('LessonsCubit: Error activating unit $unitId: $e');
        emit(LessonsError(message: 'Error activating unit: $e'));
      }
    }
  }

  void activateLesson(String unitId, String lessonId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      try {
        final updatedSubjects = currentState.subjects.map((subject) {
          final updatedUnits = subject.units.map((unit) {
            if (unit.id == unitId) {
              final updatedLessons = unit.lessons.map((lesson) {
                if (lesson.id == lessonId) {
                  if (lesson.sections.isEmpty) {
                    developer.log('LessonsCubit: Lesson $lessonId has no sections, cannot activate');
                    return lesson; // لا نفعّل إذا كانت المقاطع فارغة
                  }
                  developer.log('LessonsCubit: Activating lesson: ${lesson.id}');
                  return lesson.copyWith(isActivated: true);
                }
                return lesson;
              }).toList();
              return unit.copyWith(lessons: updatedLessons);
            }
            return unit;
          }).toList();
          return subject.copyWith(units: updatedUnits);
        }).toList();
        emit(LessonsLoaded(subjects: updatedSubjects));
      } catch (e) {
        developer.log('LessonsCubit: Error activating lesson $lessonId in unit $unitId: $e');
        emit(LessonsError(message: 'Error activating lesson: $e'));
      }
    }
  }

  void activateSection(String unitId, String lessonId, String sectionId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      try {
        final updatedSubjects = currentState.subjects.map((subject) {
          final updatedUnits = subject.units.map((unit) {
            if (unit.id == unitId) {
              final updatedLessons = unit.lessons.map((lesson) {
                if (lesson.id == lessonId) {
                  final updatedSections = lesson.sections.map((section) {
                    if (section.id == sectionId) {
                      developer.log('LessonsCubit: Activating section: ${section.id}');
                      return section.copyWith(isActivated: true);
                    }
                    return section;
                  }).toList();
                  return lesson.copyWith(sections: updatedSections);
                }
                return lesson;
              }).toList();
              return unit.copyWith(lessons: updatedLessons);
            }
            return unit;
          }).toList();
          return subject.copyWith(units: updatedUnits);
        }).toList();
        emit(LessonsLoaded(subjects: updatedSubjects));
      } catch (e) {
        developer.log('LessonsCubit: Error activating section $sectionId in lesson $lessonId: $e');
        emit(LessonsError(message: 'Error activating section: $e'));
      }
    }
  }

  void completeSection(String unitId, String lessonId, String sectionId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      try {
        final updatedSubjects = currentState.subjects.map((subject) {
          final updatedUnits = subject.units.map((unit) {
            if (unit.id == unitId) {
              final updatedLessons = unit.lessons.map((lesson) {
                if (lesson.id == lessonId) {
                  final updatedSections = lesson.sections.map((section) {
                    if (section.id == sectionId) {
                      developer.log('LessonsCubit: Completing section: ${section.id}');
                      return section.copyWith(isCompleted: true);
                    }
                    final sectionIndex = lesson.sections.indexOf(section);
                    if (sectionIndex + 1 < lesson.sections.length &&
                        lesson.sections[sectionIndex + 1].id == sectionId) {
                      developer.log('LessonsCubit: Activating next section: ${section.id}');
                      return section.copyWith(isActivated: true);
                    }
                    return section;
                  }).toList();
                  return lesson.copyWith(sections: updatedSections);
                }
                return lesson;
              }).toList();
              return unit.copyWith(lessons: updatedLessons);
            }
            return unit;
          }).toList();
          return subject.copyWith(units: updatedUnits);
        }).toList();
        emit(LessonsLoaded(subjects: updatedSubjects));
      } catch (e) {
        developer.log('LessonsCubit: Error completing section $sectionId in lesson $lessonId: $e');
        emit(LessonsError(message: 'Error completing section: $e'));
      }
    }
  }
}