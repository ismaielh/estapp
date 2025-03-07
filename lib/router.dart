
import 'package:estapps/screens/create_acount_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:estapps/screens/welcome_screen.dart';
import 'package:estapps/screens/home_screen.dart';

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