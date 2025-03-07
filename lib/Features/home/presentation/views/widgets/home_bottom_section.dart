import 'package:estapps/constants.dart';
import 'package:estapps/router.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'menu_item.dart';

// مكون الجزء السفلي مع الشبكة كـ StatelessWidget
class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: mediaQuery.width,
        height: mediaQuery.height / 1.5, // ارتفاع الجزء السفلي
        padding: Constants.sectionPadding, // حشوة خارجية
        decoration: const BoxDecoration(
          color: Constants.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Constants.borderRadiusBottom),
            topRight: Radius.circular(Constants.borderRadiusBottom),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // نص الترحيب المترجم
            Text("welcome_to_app".tr(), style: Constants.titleTextStyle),
            const SizedBox(height: 10), // مسافة بين النص والشبكة
            // شبكة العناصر بارتفاع ديناميكي
            Expanded(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, // عدد الأعمدة
                crossAxisSpacing: 8, // المسافة الأفقية بين العناصر
                mainAxisSpacing: 8, // المسافة العمودية بين العناصر
                children: [
                  MenuItem(
                    icon: Icons.person_add,
                    title: "create_account".tr(),
                    onTap: () {
                      try {
                        context.push(
                          AppRouter.createAccountScreenPath,
                        ); // استخدام push بدلاً من go
                      } catch (e) {
                        debugPrint('Navigation to /create-account failed: $e');
                      }
                    },
                  ),
                  MenuItem(
                    icon: Icons.login,
                    title: "login".tr(),
                    onTap: () {
                      context.push(
                        AppRouter.loginScreenPath,
                      ); // استخدام push بدلاً من go
                    },
                  ),
                  MenuItem(
                    icon: Icons.play_circle_fill,
                    title: "intro_video".tr(),
                    onTap: () {
                      // منطق التنقل إلى فيديو تعريفي (مثال)
                      debugPrint('Intro video tapped');
                      // context.push('/intro-video'); // أضف المسار إذا كان موجودًا
                    },
                  ),
                  MenuItem(
                    icon: Icons.info,
                    title: "about_program".tr(),
                    onTap: () {
                      // منطق التنقل إلى صفحة حول البرنامج (مثال)
                      debugPrint('About program tapped');
                      // context.push('/about'); // أضف المسار إذا كان موجودًا
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
