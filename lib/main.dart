import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/core/cubit/language_cubit/languagestate.dart';
import 'package:estapps/core/cubit/languagecubit.dart';
import 'package:estapps/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<LanguageCubit>()),
        BlocProvider<LessonsCubit>(
          create: (context) => LessonsCubit()..loadSubjects(),
        ),
      ],
      child: BlocListener<LanguageCubit, LanguageState>(
        listener: (context, state) {
          context.setLocale(Locale(state.languageCode));
        },
        child: MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          title: 'Estapps',
          theme: ThemeData(primarySwatch: Colors.blue),
        ),
      ),
    );
  }
}