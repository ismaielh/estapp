import 'package:estapps/Features/home/presentation/views/home_screen.dart';

import 'package:estapps/Features/welcom_screen/presentation/views/welcome_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// إعداد التنقل باستخدام go_router
class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
      GoRoute(
  path: '/home',
  builder: (context, state) => const HomeScreen(),
),
      GoRoute(
        path: '/create-account',
        builder:
            (context, state) => const Scaffold(
              body: Center(child: Text('Create Account Screen')),
            ),
      ),
    ],
  );
}
