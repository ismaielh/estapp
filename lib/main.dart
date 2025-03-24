import 'package:estapps/core/cubit/language_cubit/languagecubit.dart';
import 'package:estapps/core/cubit/language_cubit/languagestate.dart';
import 'package:estapps/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

// تعليق: الدالة الرئيسية لتشغيل التطبيق مع تهيئة الترجمة
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BlocProvider(
        create: (context) => LanguageCubit(),
        child: const MyApp(),
      ),
    ),
  );
}

// تعليق: التطبيق الرئيسي مع إعدادات التوجيه والسمة
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageCubit, LanguageState>(
      listener: (context, state) => context.setLocale(Locale(state.languageCode)),
      child: MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        title: 'Estapps',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.grey[100],
        ),
      ),
    );
  }
}