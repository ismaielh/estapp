import 'package:estapps/constants.dart';
import 'package:estapps/router.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

// مكون زر "Get Started" كـ StatelessWidget
class GetStartedButton extends StatelessWidget {
  const GetStartedButton({super.key, required String selectedLanguage});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          try {
            context.push(
              AppRouter.homeScreenPath,
            ); // التنقل إلى الصفحة الرئيسية
          } catch (e) {
            // تسجيل الخطأ إذا فشل التنقل
            debugPrint('Navigation failed: $e');
          }
        },
        child: Container(
          padding: Constants.buttonPadding,
          child: Text(
            "get_started".tr(),
            style: Constants.buttonTextStyle,
            textAlign: TextAlign.center, // تحسين محاذاة النص
          ),
        ),
      ),
    );
  }
}
