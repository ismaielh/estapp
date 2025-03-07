
import 'package:estapps/Features/create_acount_screen/presentation/views/widgets/custom_text_field.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';

// ويدجت تحتوي على جميع حقول النموذج لصفحة إنشاء الحساب
class AccountFormFields extends StatelessWidget {
  const AccountFormFields({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CustomTextField(
          icon: Icons.person,
          label: "student_name",
          hint: "enter_student_name",
        ),
        SizedBox(height: Constants.mediumSpacingForCreateAccount),
        CustomTextField(
          icon: Icons.person_outline,
          label: "father_name",
          hint: "enter_father_name",
        ),
        SizedBox(height: Constants.mediumSpacingForCreateAccount),
        CustomTextField(
          icon: Icons.family_restroom,
          label: "family_name",
          hint: "enter_family_name",
        ),
        SizedBox(height: Constants.mediumSpacingForCreateAccount),
        CustomTextField(
          icon: Icons.phone,
          label: "mobile_number",
          hint: "enter_mobile_number",
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: Constants.mediumSpacingForCreateAccount),
        CustomTextField(
          icon: Icons.account_circle,
          label: "username",
          hint: "enter_username",
        ),
        SizedBox(height: Constants.mediumSpacingForCreateAccount),
        CustomTextField(
          icon: Icons.lock,
          label: "password",
          hint: "enter_password",
          obscureText: true,
        ),
      ],
    );
  }
}