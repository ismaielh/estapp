import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// مكون زر إنشاء الحساب
class CreateAccountButton extends StatelessWidget {
  final VoidCallback onTap;

  const CreateAccountButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.primaryColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: Constants.buttonPadding,
          child: Text(
            "create_account_button".tr(),
            style: Constants.buttonTextStyle,
          ),
        ),
      ),
    );
  }
}