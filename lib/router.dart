import 'package:estapps/Features/activation/presentation/view/activation_screen.dart';
import 'package:estapps/Features/activation/presentation/view/select_activation_screen.dart';
import 'package:estapps/Features/create_acount_screen/presentation/views/create_acount_screen.dart';
import 'package:estapps/Features/home/presentation/views/home_screen.dart';
import 'package:estapps/Features/login_screen/presentation/view/login_screen.dart';
import 'package:estapps/Features/main_screen/presentation/view/main_screen.dart';
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
import 'dart:developer' as developer;

class AppRouter {
  static const String welcomeScreenPath = '/';
  static const String homeScreenPath = '/home';
  static const String createAccountScreenPath = '/create-account';
  static const String loginScreenPath = '/login';
  static const String mainScreenPath = '/main';
  static const String myLessonsScreenPath = '/my-lessons';
  static const String unitsScreenPath = '/units';
  static const String lessonsScreenPath = '/lessons';
  static const String activationScreenPath = '/activation';
  static const String activatedLessonScreenPath = '/activated-lesson';
  static const String selectActivationScreenPath = '/select-activation';
  static const String lessonSectionScreenPath = '/lesson-section';
  static const String quizScreenPath = '/quiz';
  static const String gradeSelectionScreenPath = '/select-grade';
  static const String subjectSelectionScreenPath = '/select-subject';
  static const String teacherSelectionScreenPath = '/select-teacher';
  static const String myTeacherScreenPath = '/my-teacher';
  static const String bookedSessionsScreenPath = '/booked-sessions';
  static const String sessionActivationScreenPath = '/session-activation';

  static final GoRouter router = GoRouter(
    initialLocation: welcomeScreenPath,
    routes: [
      GoRoute(
        path: welcomeScreenPath,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: homeScreenPath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: createAccountScreenPath,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: loginScreenPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: mainScreenPath,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: myLessonsScreenPath,
        builder: (context, state) => const MyLessonsScreen(),
      ),
      GoRoute(
        path: '$unitsScreenPath/:subjectId',
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId']!;
          developer.log('Navigating to units screen with subjectId: $subjectId');
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            developer.log('No extra data provided');
            return const Scaffold(body: Center(child: Text('No data provided')));
          }
          final subject = args['subject'] as lessons.Subject?;
          if (subject == null || subject.id != subjectId) {
            developer.log('Subject not found or mismatched with id: $subjectId');
            return const Scaffold(body: Center(child: Text('Invalid subject')));
          }
          return UnitsScreen(args: {'subject': subject});
        },
      ),
      GoRoute(
        path: '$lessonsScreenPath/:unitId',
        builder: (context, state) {
          final unitId = state.pathParameters['unitId']!;
          developer.log('Navigating to lessons screen with unitId: $unitId');
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            developer.log('No extra data provided');
            return const Scaffold(body: Center(child: Text('No data provided')));
          }
          final subject = args['subject'] as lessons.Subject;
          final unit = subject.units.firstWhere(
            (u) => u.id == unitId,
            orElse: () {
              developer.log('Unit not found with id: $unitId');
              return throw Exception('Unit not found with id: $unitId');
            },
          );
          return LessonsScreen(args: {'subject': subject, 'unit': unit});
        },
      ),
      GoRoute(
        path: activationScreenPath,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ActivationScreen(args: args);
        },
      ),
      GoRoute(
        path: '$activatedLessonScreenPath/:lessonId',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          final args = state.extra as Map<String, dynamic>;
          final subject = args['subject'] as lessons.Subject;
          final unit = args['unit'] as lessons.Unit;
          final lesson = unit.lessons.firstWhere((l) => l.id == lessonId);
          return ActivatedLessonScreen(
              args: {'subject': subject, 'unit': unit, 'lesson': lesson});
        },
      ),
      GoRoute(
        path: selectActivationScreenPath,
        builder: (context, state) => const SelectActivationScreen(),
      ),
      GoRoute(
        path: '$lessonSectionScreenPath/:sectionId',
        builder: (context, state) {
          final sectionId = state.pathParameters['sectionId']!;
          developer.log('Navigating to lesson section screen with sectionId: $sectionId');
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            developer.log('No extra data provided');
            return const Scaffold(body: Center(child: Text('No data provided')));
          }
          final subject = args['subject'] as lessons.Subject;
          final unit = args['unit'] as lessons.Unit;
          final lesson = args['lesson'] as lessons.Lesson;
          final section = lesson.sections.firstWhere(
            (s) => s.id == sectionId,
            orElse: () {
              developer.log('Section not found with id: $sectionId');
              return throw Exception('Section not found with id: $sectionId');
            },
          );
          return LessonSectionScreen(args: {
            'subject': subject,
            'unit': unit,
            'lesson': lesson,
            'section': section,
          });
        },
      ),
      GoRoute(
        path: quizScreenPath,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return QuizScreen(args: args);
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
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
            builder: (context, state) => const GradeSelectionScreen(),
          ),
          GoRoute(
            path: subjectSelectionScreenPath,
            builder: (context, state) =>
                SubjectSelectionScreen(gradeLevel: state.extra as teacher.MyGradeLevel),
          ),
          GoRoute(
            path: teacherSelectionScreenPath,
            builder: (context, state) =>
                TeacherSelectionScreen(args: state.extra as Map<String, dynamic>),
          ),
          GoRoute(
            path: myTeacherScreenPath,
            builder: (context, state) =>
                MyTeacherScreen(selectedTeacher: state.extra as teacher.MyTeacher),
          ),
          GoRoute(
            path: '/available-sessions',
            builder: (context, state) =>
                AvailableSessionsScreen(selectedTeacher: state.extra as teacher.MyTeacher),
          ),
          GoRoute(
            path: bookedSessionsScreenPath,
            builder: (context, state) =>
                BookedSessionsScreen(selectedTeacher: state.extra as teacher.MyTeacher),
          ),
          GoRoute(
            path: sessionActivationScreenPath,
            builder: (context, state) =>
                SessionActivationScreen(args: state.extra as Map<String, dynamic>),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      developer.log('Route error: ${state.error}');
      return Scaffold(
        body: Center(
          child: Text('Route Error: ${state.error}'),
        ),
      );
    },
  );
}