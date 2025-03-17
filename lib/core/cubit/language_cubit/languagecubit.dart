import 'package:estapps/core/cubit/language_cubit/languagestate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const LanguageState('ar')); // اللغة الافتراضية العربية

  void changeLanguage(String languageCode) {
    devtools.log('Changing language to: $languageCode'); // تسجيل للتحقق
    emit(LanguageState(languageCode)); // إصدار حالة جديدة عند تغيير اللغة
  }
}