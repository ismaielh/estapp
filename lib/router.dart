import 'package:estapps/Features/create_acount_screen/presentation/views/create_acount_screen.dart';
import 'package:estapps/Features/home/presentation/views/home_screen.dart';
import 'package:estapps/Features/lesson_details/presentation/view/widgets/lesson_detail_screen.dart';
import 'package:estapps/Features/login_screen/presentation/view/login_screen.dart';
import 'package:estapps/Features/main_screen/presentation/view/main_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/view/lessons_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/my_lessons_screen.dart';
import 'package:estapps/Features/my_lessons/presentation/view/units_screen.dart';

import 'package:estapps/Features/welcom_screen/presentation/views/welcome_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String welcomeScreenPath = '/';
  static const String homeScreenPath = '/home';
  static const String createAccountScreenPath = '/create-account';
  static const String loginScreenPath = '/login';
  static const String mainScreenPath = '/main';
  static const String myLessonsScreenPath = '/my-lessons';
  static const String lessonDetailScreenPath = '/lesson-detail';
  static const String unitsScreenPath = '/units';
  static const String lessonsScreenPath = '/lessons';

  static final GoRouter router = GoRouter(
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
        path: '$lessonDetailScreenPath/:lessonId',
        builder: (context, state) {
          final lessonId = state.pathParameters['lessonId']!;
          return LessonDetailScreen(lessonId: lessonId);
        },
      ),
      GoRoute(
        path: '$unitsScreenPath/:subjectId',
        builder: (context, state) {
          final subject = state.extra as Subject;
          return UnitsScreen(subject: subject);
        },
      ),
      GoRoute(
        path: '$lessonsScreenPath/:unitId',
        builder: (context, state) {
          final unitId = state.pathParameters['unitId']!;
          final args = state.extra as Map<String, dynamic>;
          final subject = args['subject'] as Subject;
          final unit = subject.units.firstWhere((u) => u.id == unitId, orElse: () => throw Exception('Unit not found'));
          return LessonsScreen(args: {'subject': subject, 'unit': unit});
        },
      ),
    ],
  );
}