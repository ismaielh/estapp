import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

// مكون زر "Get Started" كـ StatelessWidget
class GetStartedButton extends StatelessWidget {
  final String selectedLanguage;

  const GetStartedButton({super.key, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    // تحديث الترجمة بناءً على اللغة الحالية (لكن ليس ضروريًا مع easy_localization)
    return Material(
      color: Constants.primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          context.go('/home'); // التنقل إلى الصفحة الرئيسية
        },
        child: Container(
          padding: Constants.buttonPadding,
          child: Text(
            "get_started".tr(), // يجب أن يتغير تلقائيًا مع السياق
            style: Constants.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}
