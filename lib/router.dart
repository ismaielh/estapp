import 'package:estapps/Features/activation/presentation/view/activation_screen.dart';
import 'package:estapps/Features/create_acount_screen/presentation/views/create_acount_screen.dart';
import 'package:estapps/Features/home/presentation/views/home_screen.dart';
import 'package:estapps/Features/login_screen/presentation/view/login_screen.dart';
import 'package:estapps/Features/main_screen/presentation/view/main_screen.dart';
import 'package:estapps/Features/my_lessons/data/models/subject.dart' as lessons;
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart' as lessons;
import 'package:estapps/Features/my_lessons/presentation/view/lessons_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/my_lessons_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/units_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/widgets/activated_lesson_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/lesson_section_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/quiz_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/Features/my_teacher/presentation/models/teacher_models.dart' as teacher;
import 'package:estapps/Features/my_teacher/presentation/views/booked_sessions_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/views/grade_selection_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/views/my_teacher_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/views/subject_selection_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/views/teacher_selection_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/views/available_sessions_screen.dart';
import 'package:estapps/Features/my_teacher/presentation/views/session_activation_screen.dart';
import 'package:estapps/Features/welcom_screen/presentation/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class AppRouter {
  static const String welcomeScreenPath = '/';
  static const String homeScreenPath = '/home';
  static const String createAccountScreenPath = '/create-account';
  static const String loginScreenPath = '/login';
  static const String mainScreenPath = '/main';
  static const String myLessonsScreenPath = '/my-lessons';
  static const String unitsScreenPath = 'units/:subjectId';
  static const String lessonsScreenPath = 'lessons/:unitId';
  static const String activatedLessonScreenPath = 'activated-lesson/:lessonId';
  static const String lessonSectionScreenPath = 'lesson-section/:sectionId';
  static const String quizScreenPath = '/my-lessons/quiz'; // تعديل المسار ليتوافق
  static const String activationScreenPath = 'activation';
  static const String selectActivationScreenPath = '/select-activation';
  static const String gradeSelectionScreenPath = '/select-grade';
  static const String subjectSelectionScreenPath = '/select-subject';
  static const String teacherSelectionScreenPath = '/select-teacher';
  static const String myTeacherScreenPath = '/my-teacher';
  static const String bookedSessionsScreenPath = '/booked-sessions';
  static const String sessionActivationScreenPath = '/session-activation';
  static const String availableSessionsScreenPath = '/available-sessions';

  static final GoRouter router = GoRouter(
    initialLocation: welcomeScreenPath,
    routes: [
      GoRoute(
        path: welcomeScreenPath,
        builder: (context, state) {
          developer.log('Navigating to WelcomeScreen');
          return const WelcomeScreen();
        },
      ),
      GoRoute(
        path: homeScreenPath,
        builder: (context, state) {
          developer.log('Navigating to HomeScreen');
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: createAccountScreenPath,
        builder: (context, state) {
          developer.log('Navigating to CreateAccountScreen');
          return const CreateAccountScreen();
        },
      ),
      GoRoute(
        path: loginScreenPath,
        builder: (context, state) {
          developer.log('Navigating to LoginScreen');
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: mainScreenPath,
        builder: (context, state) {
          developer.log('Navigating to MainScreen');
          return const MainScreen();
        },
      ),
      GoRoute(
        path: myLessonsScreenPath,
        builder: (context, state) {
          developer.log('Navigating to MyLessonsScreen');
          return const MyLessonsScreen();
        },
        routes: [
          GoRoute(
            path: unitsScreenPath,
            builder: (context, state) {
              final subjectId = state.pathParameters['subjectId']!;
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final subject = extra['subject'] as lessons.Subject?;
              final lessonsCubit = extra['lessonsCubit'] as lessons.LessonsCubit?;
              if (subject == null || subject.id != subjectId || lessonsCubit == null) {
                developer.log('Error: Invalid or missing subject/lessonsCubit for subjectId: $subjectId');
                return const Scaffold(body: Center(child: Text('Invalid subject or data')));
              }
              developer.log('Navigating to UnitsScreen with subjectId: $subjectId');
              return UnitsScreen(subject: subject, lessonsCubit: lessonsCubit);
            },
          ),
          GoRoute(
            path: lessonsScreenPath,
            builder: (context, state) {
              final unitId = state.pathParameters['unitId']!;
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final subject = extra['subject'] as lessons.Subject?;
              final unit = extra['unit'] as lessons.Unit?;
              final lessonsCubit = extra['lessonsCubit'] as lessons.LessonsCubit?;
              if (subject == null || unit == null || unit.id != unitId || lessonsCubit == null) {
                developer.log('Error: Invalid or missing data for unitId: $unitId');
                return const Scaffold(body: Center(child: Text('Invalid subject or unit')));
              }
              developer.log('Navigating to LessonsScreen with unitId: $unitId');
              return LessonsScreen(subject: subject, unit: unit, lessonsCubit: lessonsCubit);
            },
          ),
          GoRoute(
            path: activatedLessonScreenPath,
            builder: (context, state) {
              final lessonId = state.pathParameters['lessonId']!;
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final subject = extra['subject'] as lessons.Subject?;
              final unit = extra['unit'] as lessons.Unit?;
              final lesson = extra['lesson'] as lessons.Lesson?;
              final lessonsCubit = extra['lessonsCubit'] as lessons.LessonsCubit?;
              if (subject == null || unit == null || lesson == null || lesson.id != lessonId || lessonsCubit == null) {
                developer.log('Error: Invalid or missing data for lessonId: $lessonId');
                return const Scaffold(body: Center(child: Text('Invalid lesson data')));
              }
              developer.log('Navigating to ActivatedLessonScreen with lessonId: $lessonId');
              return ActivatedLessonScreen(subject: subject, unit: unit, lesson: lesson, lessonsCubit: lessonsCubit);
            },
          ),
          GoRoute(
            path: lessonSectionScreenPath,
            builder: (context, state) {
              final sectionId = state.pathParameters['sectionId']!;
              final extra = state.extra as Map<String, dynamic>? ?? {};
              developer.log('Extra data for LessonSectionScreen: $extra');
              final subject = extra['subject'] as lessons.Subject?;
              final unit = extra['unit'] as lessons.Unit?;
              final lesson = extra['lesson'] as lessons.Lesson?;
              final section = extra['section'] as lessons.Section?;
              final lessonsCubit = extra['lessonsCubit'] as lessons.LessonsCubit?;

              if (subject == null) {
                developer.log('Error: Subject is null for sectionId: $sectionId');
                return const Scaffold(body: Center(child: Text('Missing subject data')));
              }
              if (unit == null) {
                developer.log('Error: Unit is null for sectionId: $sectionId');
                return const Scaffold(body: Center(child: Text('Missing unit data')));
              }
              if (lesson == null) {
                developer.log('Error: Lesson is null for sectionId: $sectionId');
                return const Scaffold(body: Center(child: Text('Missing lesson data')));
              }
              if (section == null || section.id != sectionId) {
                developer.log('Error: Section is null or ID mismatch for sectionId: $sectionId');
                return const Scaffold(body: Center(child: Text('Invalid section data')));
              }
              if (lessonsCubit == null) {
                developer.log('Error: LessonsCubit is null for sectionId: $sectionId');
                return const Scaffold(body: Center(child: Text('Missing LessonsCubit')));
              }

              developer.log('Navigating to LessonSectionScreen with sectionId: $sectionId');
              return BlocProvider.value(
                value: lessonsCubit,
                child: LessonSectionScreen(args: {
                  'subject': subject,
                  'unit': unit,
                  'lesson': lesson,
                  'section': section,
                }),
              );
            },
          ),
          GoRoute(
            path: 'quiz', // تغيير المسار إلى 'quiz' كجزء فرعي من /my-lessons
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final subject = extra['subject'] as lessons.Subject?;
              final unit = extra['unit'] as lessons.Unit?;
              final lesson = extra['lesson'] as lessons.Lesson?;
              final section = extra['section'] as lessons.Section?;
              final lessonsCubit = extra['lessonsCubit'] as lessons.LessonsCubit?;
              if (subject == null || unit == null || lesson == null || section == null || lessonsCubit == null) {
                developer.log('Error: Missing data for QuizScreen');
                return const Scaffold(body: Center(child: Text('Invalid quiz data')));
              }
              developer.log('Navigating to QuizScreen');
              return BlocProvider.value(
                value: lessonsCubit,
                child: QuizScreen(args: {
                  'subject': subject,
                  'unit': unit,
                  'lesson': lesson,
                  'section': section,
                }),
              );
            },
          ),
          GoRoute(
            path: activationScreenPath,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final subject = extra['subject'] as lessons.Subject?;
              final unit = extra['unit'] as lessons.Unit?;
              final lesson = extra['lesson'] as lessons.Lesson?;
              final lessonsCubit = extra['lessonsCubit'] as lessons.LessonsCubit?;
              if (subject == null && unit == null && lesson == null) {
                developer.log('Error: Missing data for ActivationScreen');
                return const Scaffold(body: Center(child: Text('Invalid activation data')));
              }
              developer.log('Navigating to ActivationScreen');
              return BlocProvider.value(
                value: lessonsCubit ?? context.read<lessons.LessonsCubit>(),
                child: ActivationScreen(args: {
                  'subject': subject,
                  'unit': unit,
                  'lesson': lesson,
                }),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) {
          developer.log('Initializing TeacherCubit for MyTeacher routes');
          return BlocProvider(
            create: (context) {
              final cubit = TeacherCubit();
              cubit.loadData();
              return cubit;
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: gradeSelectionScreenPath,
            builder: (context, state) {
              developer.log('Navigating to GradeSelectionScreen');
              return const GradeSelectionScreen();
            },
          ),
          GoRoute(
            path: subjectSelectionScreenPath,
            builder: (context, state) {
              final gradeLevel = state.extra as teacher.MyGradeLevel?;
              if (gradeLevel == null) {
                developer.log('Error: Missing gradeLevel for SubjectSelectionScreen');
                return const Scaffold(body: Center(child: Text('Invalid grade data')));
              }
              developer.log('Navigating to SubjectSelectionScreen');
              return SubjectSelectionScreen(gradeLevel: gradeLevel);
            },
          ),
          GoRoute(
            path: teacherSelectionScreenPath,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>? ?? {};
              if (args.isEmpty) {
                developer.log('Error: Missing args for TeacherSelectionScreen');
                return const Scaffold(body: Center(child: Text('Invalid teacher data')));
              }
              developer.log('Navigating to TeacherSelectionScreen');
              return TeacherSelectionScreen(args: args);
            },
          ),
          GoRoute(
            path: myTeacherScreenPath,
            builder: (context, state) {
              final selectedTeacher = state.extra as teacher.MyTeacher?;
              if (selectedTeacher == null) {
                developer.log('Error: Missing selectedTeacher for MyTeacherScreen');
                return const Scaffold(body: Center(child: Text('Invalid teacher data')));
              }
              developer.log('Navigating to MyTeacherScreen');
              return MyTeacherScreen(selectedTeacher: selectedTeacher);
            },
          ),
          GoRoute(
            path: availableSessionsScreenPath,
            builder: (context, state) {
              final selectedTeacher = state.extra as teacher.MyTeacher?;
              if (selectedTeacher == null) {
                developer.log('Error: Missing selectedTeacher for AvailableSessionsScreen');
                return const Scaffold(body: Center(child: Text('Invalid teacher data')));
              }
              developer.log('Navigating to AvailableSessionsScreen');
              return AvailableSessionsScreen(selectedTeacher: selectedTeacher);
            },
          ),
          GoRoute(
            path: bookedSessionsScreenPath,
            builder: (context, state) {
              final selectedTeacher = state.extra as teacher.MyTeacher?;
              if (selectedTeacher == null) {
                developer.log('Error: Missing selectedTeacher for BookedSessionsScreen');
                return const Scaffold(body: Center(child: Text('Invalid teacher data')));
              }
              developer.log('Navigating to BookedSessionsScreen');
              return BookedSessionsScreen(selectedTeacher: selectedTeacher);
            },
          ),
          GoRoute(
            path: sessionActivationScreenPath,
            builder: (context, state) {
              final args = state.extra as Map<String, dynamic>? ?? {};
              if (args.isEmpty) {
                developer.log('Error: Missing args for SessionActivationScreen');
                return const Scaffold(body: Center(child: Text('Invalid session data')));
              }
              developer.log('Navigating to SessionActivationScreen');
              return SessionActivationScreen(args: args);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      developer.log('Route error: ${state.error}');
      return Scaffold(
        body: Center(
          child: Text('navigation_error'.tr(args: [state.error.toString()])),
        ),
      );
    },
  );

  static GoRouter getRouter() {
    return router;
  }
}