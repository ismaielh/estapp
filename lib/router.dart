
import 'package:estapps/Features/create_acount_screen/presentation/views/create_acount_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:estapps/Features/welcom_screen/presentation/views/welcome_screen.dart';
import 'package:estapps/Features/home/presentation/views/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
  path: '/create-account',
  builder: (context, state) => const CreateAccountScreen(),
),
  ],
);