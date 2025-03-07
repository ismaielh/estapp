import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';
import 'dart:developer' as devtools show log;

// Bloc لإدارة حالة اللغة
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState('ar')) { // اللغة الافتراضية هي العربية
    on<ChangeLanguageEvent>((event, emit) {
      devtools.log('Changing language to: ${event.languageCode}'); // تسجيل للتحقق
      emit(LanguageState(event.languageCode)); // إصدار حالة جديدة عند تغيير اللغة
    });
  }
}