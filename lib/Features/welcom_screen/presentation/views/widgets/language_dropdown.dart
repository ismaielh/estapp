import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

// مكون قائمة اللغة كـ StatelessWidget
class LanguageDropdown extends StatefulWidget {
  final Function(String?) onChanged;

  const LanguageDropdown({
    super.key,
    required this.onChanged, required String selectedLanguage,
  });

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage(); // تحميل اللغة المحفوظة عند بدء التشغيل
  }

  // تحميل اللغة المحفوظة من SharedPreferences
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language_code') ?? context.locale.languageCode;
    });
  }

  // حفظ اللغة المختارة في SharedPreferences
  Future<void> _saveLanguage(String? language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', language ?? 'ar'); // الافتراضي 'ar' إذا كان null
    await context.setLocale(Locale(language ?? 'ar')); // تحديث لغة التطبيق
    if (widget.onChanged != null) {
      widget.onChanged(language); // إشعار الأب بالتغيير
    }
  }

  // دالة مساعدة للتحقق من صحة اللغة
  bool _isValidLanguage(String language) {
    return ['en', 'ar'].contains(language);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _isValidLanguage(_selectedLanguage ?? '') ? _selectedLanguage : null,
      hint: Text("select_language".tr()),
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
      ],
      onChanged: (newValue) {
        if (newValue != null && _isValidLanguage(newValue)) {
          setState(() {
            _selectedLanguage = newValue;
          });
          _saveLanguage(newValue); // حفظ اللغة الجديدة
        }
      },
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      underline: const SizedBox(),
    );
  }
}