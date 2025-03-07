import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// مكون قائمة اللغة كـ StatelessWidget
class LanguageDropdown extends StatelessWidget {
  final String selectedLanguage;
  final Function(String?) onChanged;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _isValidLanguage(selectedLanguage) ? selectedLanguage : null, // تأكد من القيمة الصحيحة
      hint: Text("select_language".tr()),
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
      ],
      onChanged: (newValue) {
        if (newValue != null) {
          onChanged(newValue); // استدعاء الدالة فقط إذا كانت القيمة غير null
        }
      },
      style: const TextStyle(color: Colors.black), // تحسين مظهر النص
      dropdownColor: Colors.white, // خلفية القائمة المنسدلة
      underline: const SizedBox(), // إزالة الخط السفلي الافتراضي
    );
  }

  // دالة مساعدة للتحقق من صحة اللغة
  bool _isValidLanguage(String language) {
    return ['en', 'ar'].contains(language);
  }
}