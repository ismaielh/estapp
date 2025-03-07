import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:estapps/router.dart';
import 'package:go_router/go_router.dart'; // استيراد ملف التوجيه

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')], // اللغات المدعومة
      path: 'assets/translations', // مسار ملفات الترجمة
      fallbackLocale: Locale('ar'), // اللغة الافتراضية هي العربية
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = router; // استخدام التوجيه من router.dart

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router, // تكوين التوجيه
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    );
  }
}
