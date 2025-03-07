import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// مكون زر تسجيل الدخول
class LoginButton extends StatelessWidget {
  final VoidCallback onTap;

  const LoginButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 200.0, // عرض ثابت للزر
          height: 50.0, // ارتفاع ثابت للزر
          child: Container(
            padding: Constants.buttonPadding,
            alignment: Alignment.center, // محاذاة النص في المنتصف
            child: Text(
              "login_button".tr(),
              style: Constants.buttonTextStyle,
              textAlign: TextAlign.center, // محاذاة النص داخل الزر
            ),
          ),
        ),
      ),
    );
  }
}
