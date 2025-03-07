import 'package:estapps/Features/create_acount_screen/presentation/views/widgets/custom_text_field.dart';

import 'package:estapps/Features/login_screen/presentation/view/widgets/login_button.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// مكون الجزء السفلي الذي يحتوي على نموذج تسجيل الدخول
class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    // الحصول على أبعاد الشاشة الحالية لتحديد الأبعاد الديناميكية
    var mediaQuery = MediaQuery.of(context).size;

    return Align(
      // محاذاة الحاوية إلى الجزء السفلي من الشاشة
      alignment: Alignment.bottomCenter,
      child: Container(
        // ضبط العرض ليكون مساويًا لعرض الشاشة
        width: mediaQuery.width,
        // ضبط الارتفاع بناءً على نسبة الارتفاع المحددة في Constants
        height: mediaQuery.height / Constants.bottomSectionHeightRatioForLogin,
        // إضافة حشوة خارجية باستخدام الثابت المحدد في Constants
        padding: Constants.sectionPadding,
        decoration: const BoxDecoration(
          // تعيين لون الخلفية الأبيض من الثوابت
          color: Constants.backgroundColor,
          borderRadius: BorderRadius.only(
            // إضافة زوايا مستديرة في الأعلى الأيسر
            topLeft: Radius.circular(Constants.borderRadiusBottom),
            // إضافة زوايا مستديرة في الأعلى الأيمن
            topRight: Radius.circular(Constants.borderRadiusBottom),
          ),
        ),
        child: Column(
          // محاذاة العناصر في المنتصف عموديًا
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            // عرض عنوان الصفحة مترجمًا باستخدام easy_localization
            Text(
              "login_title".tr(),
              style: Constants.titleTextStyle.copyWith(
                fontSize: 40,
              ), // تطبيق نمط النص المحدد في الثوابت
            ),
            const SizedBox(
              // إضافة مسافة عمودية كبيرة بين العنوان والنموذج
              height: Constants.largeSpacingForLogin + 10,
            ),
            const CustomTextField(
              icon: Icons.account_circle,
              label: "username",
              hint: "enter_username",
            ),
            const SizedBox(
              // إضافة مسافة عمودية متوسطة بين الحقول
              height: Constants.mediumSpacingForLogin + 5,
            ),
            const CustomTextField(
              icon: Icons.lock,
              label: "password",
              hint: "enter_password",
              obscureText: true,
            ),
            const SizedBox(
              // إضافة مسافة عمودية كبيرة بين النموذج والزر
              height: Constants.largeSpacingForLogin + 40,
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: LoginButton(
                // استدعاء زر تسجيل الدخول مع دالة عند الضغط
                onTap: () {
                  // طباعة رسالة في وحدة التحكم عند الضغط على الزر
                  debugPrint('Login tapped');
                },
              ),
            ),
            SizedBox(
              // إضافة مسافة سفلية ديناميكية لتجنب تغطية المحتوى بلوحة المفاتيح
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
