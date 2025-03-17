import 'package:easy_localization/easy_localization.dart';
import 'package:estapps/Features/my_teacher/presentation/models/teacher_models.dart' as teacher;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit() : super(TeacherInitial());

  // متغير للتحكم في عدد الجلسات المسموح بحجزها في اليوم
  final int maxSessionsPerDay = 2; // يمكن للشركة تغيير هذا الرقم

  void loadData() {
    emit(TeacherLoading());
    try {
      final gradeLevels = [
        teacher.MyGradeLevel(id: 'grade7', title: 'Grade 7'),
        teacher.MyGradeLevel(id: 'grade8', title: 'Grade 8'),
        teacher.MyGradeLevel(id: 'grade9', title: 'Grade 9'),
        teacher.MyGradeLevel(id: 'grade10', title: 'Grade 10'),
        teacher.MyGradeLevel(id: 'grade11', title: 'Grade 11'),
        teacher.MyGradeLevel(id: 'grade12', title: 'Baccalaureate'),
      ];

      final subjects = [
        teacher.MySubject(id: 'math', title: 'Mathematics', gradeLevelId: 'grade7'),
        teacher.MySubject(id: 'science', title: 'Science', gradeLevelId: 'grade7'),
        teacher.MySubject(id: 'math', title: 'Mathematics', gradeLevelId: 'grade8'),
        teacher.MySubject(id: 'physics', title: 'Physics', gradeLevelId: 'grade12'),
      ];

      final teachers = [
        teacher.MyTeacher(
          id: 'teacher1',
          name: 'Teacher A',
          subjectId: 'math',
          sessions: [
            teacher.MySession(
              id: 'session1',
              teacherId: 'teacher1',
              date: DateTime.now().add(const Duration(days: 1)),
              duration: const Duration(minutes: 10),
              price: 5000.0,
            ),
            teacher.MySession(
              id: 'session2',
              teacherId: 'teacher1',
              date: DateTime.now().add(const Duration(days: 2)),
              duration: const Duration(minutes: 10),
              price: 5000.0,
            ),
          ],
        ),
        teacher.MyTeacher(
          id: 'teacher2',
          name: 'Teacher B',
          subjectId: 'science',
          sessions: [
            teacher.MySession(
              id: 'session3',
              teacherId: 'teacher2',
              date: DateTime.now().add(const Duration(days: 3)),
              duration: const Duration(minutes: 10),
              price: 6000.0,
            ),
            teacher.MySession(
              id: 'session4',
              teacherId: 'teacher2',
              date: DateTime.now().add(const Duration(days: 4)),
              duration: const Duration(minutes: 10),
              price: 6000.0,
            ),
          ],
        ),
      ];

      developer.log('TeacherCubit: Data loaded successfully');
      emit(TeacherLoaded(
        gradeLevels: gradeLevels,
        subjects: subjects,
        teachers: teachers,
      ));
    } catch (e) {
      developer.log('TeacherCubit: Failed to load data: $e');
      emit(TeacherError(message: 'Failed to load data: $e'));
    }
  }

  bool canBookSession(String teacherId, DateTime sessionDate) {
    if (state is TeacherLoaded) {
      final currentState = state as TeacherLoaded;
      final selectedTeacher = currentState.teachers.firstWhere((t) => t.id == teacherId);
      final bookedSessionsOnDate = selectedTeacher.sessions
          .where((session) =>
              session.isBooked &&
              session.date.day == sessionDate.day &&
              session.date.month == sessionDate.month &&
              session.date.year == sessionDate.year)
          .length;
      return bookedSessionsOnDate < maxSessionsPerDay;
    }
    return false;
  }

  void bookSession(String teacherId, String sessionId) {
    if (state is TeacherLoaded) {
      final currentState = state as TeacherLoaded;
      final selectedTeacher = currentState.teachers.firstWhere((t) => t.id == teacherId);
      final session = selectedTeacher.sessions.firstWhere((s) => s.id == sessionId);

      if (!canBookSession(teacherId, session.date)) {
        emit(TeacherError(message: 'max_sessions_per_day_reached'.tr()));
        return;
      }

      try {
        final updatedTeachers = currentState.teachers.map((t) {
          if (t != null && t.id == teacherId) {
            final updatedSessions = t.sessions.map((s) {
              if (s != null && s.id == sessionId) {
                developer.log('TeacherCubit: Booking session: ${s.id}');
                return s.copyWith(isBooked: true);
              }
              return s;
            }).toList();
            return t.copyWith(sessions: updatedSessions);
          }
          return t;
        }).whereType<teacher.MyTeacher>().toList();

        emit(TeacherLoaded(
          gradeLevels: currentState.gradeLevels,
          subjects: currentState.subjects,
          teachers: updatedTeachers,
        ));
      } catch (e) {
        developer.log('TeacherCubit: Error booking session $sessionId: $e');
        emit(TeacherError(message: 'Error booking session: $e'));
      }
    }
  }

  bool canStartVideoCall(DateTime sessionDate) {
    final now = DateTime.now();
    final difference = sessionDate.difference(now).inMinutes;
    return difference <= 5 && difference >= 0;
  }
}