// lib/Features/my_lessons/presentation/manager/cubit/lessons_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:estapps/Features/my_lessons/data/models/subject.dart';
import 'package:flutter/material.dart';
import 'lessons_state.dart';
import 'dart:developer' as developer;

// تعليق: كلاس لإدارة حالة الدروس باستخدام Cubit، يتم إنشاؤه وإغلاقه مع صفحة "دروسي"
class LessonsCubit extends Cubit<LessonsState> {
  // تعليق: تهيئة Cubit بحالة البداية
  LessonsCubit() : super(LessonsInitial());

  // تعليق: دالة لتحميل قائمة المواد عند فتح صفحة "دروسي"
  void loadSubjects() {
    emit(LessonsLoading()); // تعليق: إصدار حالة التحميل أثناء جلب البيانات
    try {
      // تعليق: قائمة المواد الافتراضية للتجربة (يمكن استبدالها ببيانات من API لاحقًا)
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
                    Section(id: 'sec1', title: 'Introduction', isActivated: true, videoId: 'dQw4w9WgXcQ'),
                    Section(id: 'sec2', title: 'Main Content', videoId: 'xyz123'),
                  ],
                  isActivated: true,
                ),
                Lesson(
                  id: 'lesson2',
                  title: '2',
                  sections: [
                    Section(id: 'sec1', title: 'Introduction', videoId: 'abc456'),
                    Section(id: 'sec2', title: 'Main Content', videoId: 'def789'),
                  ],
                ),
              ],
            ),
            Unit(
              id: 'unit2',
              title: '2',
              lessons: [
                Lesson(
                  id: 'lesson3',
                  title: '3',
                  sections: [
                    Section(id: 'sec1', title: 'Introduction', videoId: 'ghi012'),
                    Section(id: 'sec2', title: 'Main Content', videoId: 'jkl345'),
                  ],
                ),
                Lesson(
                  id: 'lesson4',
                  title: '4',
                  sections: [
                    Section(id: 'sec1', title: 'Introduction', videoId: 'mno678'),
                    Section(id: 'sec2', title: 'Main Content', videoId: 'pqr901'),
                  ],
                ),
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
                Lesson(
                  id: 'lesson5',
                  title: '5',
                  sections: [
                    Section(id: 'sec1', title: 'Introduction', videoId: 'stu234'),
                    Section(id: 'sec2', title: 'Main Content', videoId: 'vwx567'),
                  ],
                ),
                Lesson(
                  id: 'lesson6',
                  title: '6',
                  sections: [
                    Section(id: 'sec1', title: 'Introduction', videoId: 'yza890'),
                    Section(id: 'sec2', title: 'Main Content', videoId: 'bcd123'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ];
      if (subjects.isEmpty) {
        developer.log('LessonsCubit: No subjects loaded');
        emit(LessonsError(message: 'no_subjects_available'.tr())); // تعليق: إصدار حالة خطأ إذا لم تُوجد مواد
        return;
      }
      emit(LessonsLoaded(subjects: subjects)); // تعليق: إصدار حالة النجاح مع قائمة المواد
    } catch (e) {
      developer.log('LessonsCubit: Failed to load subjects: $e');
      emit(LessonsError(message: 'Failed to load subjects: $e')); // تعليق: إصدار حالة خطأ في حالة الفشل
    }
  }

  // تعليق: دالة لتفعيل وحدة معينة بناءً على معرفها
  void activateUnit(String unitId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      final updatedSubjects = currentState.subjects.map((subject) {
        final updatedUnits = subject.units.map((unit) {
          if (unit.id == unitId && !unit.isActivated) {
            developer.log('LessonsCubit: Activating unit: ${unit.id}');
            return unit.copyWith(isActivated: true); // تعليق: تفعيل الوحدة إذا لم تكن مفعلة
          }
          return unit;
        }).toList();
        return subject.copyWith(units: updatedUnits);
      }).toList();
      emit(LessonsLoaded(subjects: updatedSubjects)); // تعليق: تحديث الحالة بعد التفعيل
    }
  }

  // تعليق: دالة لتفعيل درس معين داخل وحدة
  void activateLesson(String unitId, String lessonId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      final updatedSubjects = currentState.subjects.map((subject) {
        final updatedUnits = subject.units.map((unit) {
          if (unit.id == unitId) {
            final updatedLessons = unit.lessons.map((lesson) {
              if (lesson.id == lessonId && !lesson.isActivated) {
                developer.log('LessonsCubit: Activating lesson: ${lesson.id}');
                final updatedSections = lesson.sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  if (index == 0 && !section.isActivated) {
                    return section.copyWith(isActivated: true); // تعليق: تفعيل القسم الأول تلقائيًا
                  }
                  return section;
                }).toList();
                return lesson.copyWith(isActivated: true, sections: updatedSections);
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
    }
  }

  // تعليق: دالة لتفعيل قسم معين داخل درس
  void activateSection(String unitId, String lessonId, String sectionId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      final updatedSubjects = currentState.subjects.map((subject) {
        final updatedUnits = subject.units.map((unit) {
          if (unit.id == unitId) {
            final updatedLessons = unit.lessons.map((lesson) {
              if (lesson.id == lessonId) {
                final updatedSections = lesson.sections.map((section) {
                  if (section.id == sectionId && !section.isActivated) {
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
    }
  }

  // تعليق: دالة لإكمال قسم معين وتفعيل القسم التالي إن وجد
  void completeSection(String unitId, String lessonId, String sectionId) {
    if (state is LessonsLoaded) {
      final currentState = state as LessonsLoaded;
      final updatedSubjects = currentState.subjects.map((subject) {
        final updatedUnits = subject.units.map((unit) {
          if (unit.id == unitId) {
            final updatedLessons = unit.lessons.map((lesson) {
              if (lesson.id == lessonId) {
                final sectionIndex = lesson.sections.indexWhere((s) => s.id == sectionId);
                if (sectionIndex == -1) return lesson;
                final updatedSections = lesson.sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  if (section.id == sectionId && !section.isCompleted) {
                    developer.log('LessonsCubit: Completing section: ${section.id}');
                    return section.copyWith(isCompleted: true);
                  }
                  return section;
                }).toList();
                if (sectionIndex + 1 < lesson.sections.length) {
                  final nextSection = lesson.sections[sectionIndex + 1];
                  if (!nextSection.isActivated && !nextSection.isCompleted) {
                    developer.log('LessonsCubit: Activating next section: ${nextSection.id}');
                    updatedSections[sectionIndex + 1] = nextSection.copyWith(isActivated: true);
                  }
                }
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
    }
  }
}