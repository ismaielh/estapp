import 'package:flutter/material.dart';

// ملف لتخزين الثوابت المتكررة
class Constants {
  // الألوان
  static const Color primaryColor = Color(0xff674AEF);
  static const Color backgroundColor = Colors.white;
  static const Color textFieldFillColorForCreateAccount = Color(
    0xFFF5F5F5,
  ); // لـ CreateAccountScreen
  static const Color errorColorForCreateAccount =
      Colors.red; // لـ CreateAccountScreen
  static const Color textFieldFillColorForLogin = Color(
    0xFFF5F5F5,
  ); // لون تعبئة حقل النص لـ LoginScreen

  // الصور
  static const String booksImage = 'assets/images/books.png';

  // الأحجام والنسب
  static const double topSectionHeightRatio = 1.6;
  static const double bottomSectionHeightRatio = 2.6;
  static const double topSectionHeightRatioForCreateAccount =
      1.6; // لـ CreateAccountScreen
  static const double bottomSectionHeightRatioForCreateAccount =
      1.5; // لـ CreateAccountScreen
  static const double topSectionHeightRatioForLogin = 1.76; // لـ LoginScreen
  static const double bottomSectionHeightRatioForLogin = 1.83; // لـ LoginScreen
  static const double borderRadiusTop = 80.0;
  static const double borderRadiusBottom = 70.0;
  static const double buttonPaddingVertical = 10.0;
  static const double buttonPaddingHorizontal = 60.0;
  static const double textPadding = 20.0;
  static const double iconScale = 0.8;
  static const double textFieldWidthForCreateAccount =
      300.0; // لـ CreateAccountScreen
  static const double mediumSpacingForCreateAccount =
      10.0; // لـ CreateAccountScreen
  static const double largeSpacingForCreateAccount =
      20.0; // لـ CreateAccountScreen
  static const double textFieldWidthForLogin =
      300.0; // عرض حقل النص لـ LoginScreen
  static const double mediumSpacingForLogin =
      10.0; // مسافة متوسطة لـ LoginScreen
  static const double largeSpacingForLogin = 20.0; // مسافة كبيرة لـ LoginScreen

  // الأنماط النصية
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  static const TextStyle subTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    wordSpacing: 2,
  );
  static const TextStyle descriptionTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  // المسافات
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: buttonPaddingVertical,
    horizontal: buttonPaddingHorizontal,
  );
  static const EdgeInsets sectionPadding = EdgeInsets.all(textPadding);
}
