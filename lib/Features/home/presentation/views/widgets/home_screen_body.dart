import 'package:estapps/Features/home/presentation/views/widgets/home_bottom_section.dart';
import 'package:estapps/Features/home/presentation/views/widgets/home_top_background.dart';
import 'package:estapps/core/cubit/language_cubit/languagestate.dart';
import 'package:estapps/core/cubit/language_cubit/languagecubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as devtools show log;

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size; // الحصول على أبعاد الشاشة

    return BlocConsumer<LanguageCubit, LanguageState>( // تغيير إلى LanguageCubit
      listener: (context, state) {
        devtools.log(
          'Setting locale to: ${state.languageCode}',
        ); // تسجيل للتحقق
        context.setLocale(Locale(state.languageCode)); // تغيير اللغة
      },
      builder: (context, state) {
        return Material(
          child: SizedBox(
            width: mediaQuery.width, // عرض الشاشة الكامل
            height: mediaQuery.height, // ارتفاع الشاشة الكامل
            child: Stack(
              children: const [
                TopBackground(), // الخلفية العلوية
                BottomSection(), // الجزء السفلي مع الشبكة
              ],
            ),
          ),
        );
      },
    );
  }
}