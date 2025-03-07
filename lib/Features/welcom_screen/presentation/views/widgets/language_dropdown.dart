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
      value: selectedLanguage,
      hint: Text("select_language".tr()),
      items: const [
        DropdownMenuItem(value: 'en', child: Text('English')),
        DropdownMenuItem(value: 'ar', child: Text('العربية')),
      ],
      onChanged: onChanged,
    );
  }
}