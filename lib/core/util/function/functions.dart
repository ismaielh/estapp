import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// ملف لتخزين الدوال المنطقية المتكررة
class Functions {
  // دالة لتغيير اللغة ديناميكيًا
  static void changeLanguage(BuildContext context, String? newValue, Function(String) setStateCallback) {
    if (newValue != null) {
      setStateCallback(newValue);
      context.setLocale(Locale(newValue)); // تغيير اللغة ديناميكيًا
    }
  }
}