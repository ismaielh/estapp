import 'package:estapps/Features/create_acount_screen/presentation/views/create_acount_screen.dart';
import 'package:estapps/Features/home/presentation/views/home_screen.dart';
import 'package:estapps/Features/login_screen/presentation/view/login_screen.dart';
import 'package:estapps/Features/welcom_screen/presentation/views/welcome_screen.dart';
import 'package:go_router/go_router.dart';

// إعداد التنقل باستخدام go_router
class AppRouter {
  // تعريف متغيرات لتخزين أسماء المسارات (paths) لكل صفحة
  static const String welcomeScreenPath = '/'; // مسار الصفحة الترحيبية
  static const String homeScreenPath = '/home'; // مسار الصفحة الرئيسية
  static const String createAccountScreenPath = '/create-account'; // مسار صفحة إنشاء الحساب
  static const String loginScreenPath = '/login'; // مسار صفحة تسجيل الدخول

  // إعداد الروتات باستخدام go_router
  static final GoRouter router = GoRouter(
    routes: [
      // مسار الصفحة الترحيبية باستخدام المتغير
      GoRoute(
        path: welcomeScreenPath,
        builder: (context, state) => const WelcomeScreen(),
      ),
      // مسار الصفحة الرئيسية باستخدام المتغير
      GoRoute(
        path: homeScreenPath,
        builder: (context, state) => const HomeScreen(),
      ),
      // مسار صفحة إنشاء الحساب باستخدام المتغير
      GoRoute(
        path: createAccountScreenPath,
        builder: (context, state) => const CreateAccountScreen(),
      ),
      // مسار صفحة تسجيل الدخول باستخدام المتغير
      GoRoute(
        path: loginScreenPath,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}