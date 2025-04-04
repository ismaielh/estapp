import 'package:estapps/Features/welcom_screen/presentation/views/widgets/bottom_section.dart';
import 'package:estapps/Features/welcom_screen/presentation/views/widgets/top_background.dart';
import 'package:estapps/core/cubit/language_cubit/languagestate.dart';
import 'package:estapps/core/cubit/language_cubit/languagecubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as devtools show log;

class WelcomeScreenBody extends StatelessWidget {
  const WelcomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return BlocConsumer<LanguageCubit, LanguageState>( // تغيير إلى LanguageCubit
      listener: (context, state) {
        devtools.log('Setting locale to: ${state.languageCode}');
        context.setLocale(Locale(state.languageCode));
      },
      builder: (context, state) {
        return Material(
          child: SizedBox(
            width: mediaQuery.width,
            height: mediaQuery.height,
            child: Stack(
              children: [
                const TopBackground(),
                BottomSection(
                  selectedLanguage: state.languageCode,
                  onLanguageChanged: (newValue) {
                    if (newValue != null) {
                      devtools.log('Language changed to: $newValue');
                      context.read<LanguageCubit>().changeLanguage(newValue); // تغيير إلى changeLanguage
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}