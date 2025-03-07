import 'package:estapps/Features/create_acount_screen/presentation/views/widgets/account_form_fields.dart';
import 'package:estapps/Features/create_acount_screen/presentation/views/widgets/create_account_button.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// مكون الجزء السفلي الذي يحتوي على النموذج لصفحة إنشاء الحساب
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
        height: mediaQuery.height / Constants.bottomSectionHeightRatioForCreateAccount,
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
        child: SingleChildScrollView(
          // إضافة مسافة سفلية ديناميكية عند ظهور لوحة المفاتيح
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            // محاذاة العناصر في المنتصف عموديًا
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عرض عنوان الصفحة مترجمًا باستخدام easy_localization
              Text(
                "create_account_title".tr(),
                style: Constants.titleTextStyle, // تطبيق نمط النص المحدد في الثوابت
              ),
              const SizedBox(
                // إضافة مسافة عمودية كبيرة بين العنوان والنموذج
                height: Constants.largeSpacingForCreateAccount,
              ),
              const AccountFormFields(), // استدعاء ويدجت الحقول المخصصة للنموذج
              const SizedBox(
                // إضافة مسافة عمودية كبيرة بين النموذج والزر
                height: Constants.largeSpacingForCreateAccount,
              ),
              CreateAccountButton(
                // استدعاء زر إنشاء الحساب مع دالة عند الضغط
                onTap: () {
                  // طباعة رسالة في وحدة التحكم عند الضغط على الزر
                  debugPrint('Create Account tapped');
                },
              ),
              SizedBox(
                // إضافة مسافة سفلية ديناميكية لتجنب تغطية المحتوى بلوحة المفاتيح
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}