import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// مكون حقل نص مخصص
class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Constants.textFieldWidthForCreateAccount,
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Constants.primaryColor),
          labelText: label.tr(),
          hintText: hint.tr(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Constants.textFieldFillColorForCreateAccount,
        ),
      ),
    );
  }
}