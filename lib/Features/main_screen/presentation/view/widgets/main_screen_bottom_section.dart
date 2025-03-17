import 'package:estapps/Features/main_screen/presentation/view/widgets/main_screen_grid_item.dart';
import 'package:estapps/constants.dart';
import 'package:estapps/router.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

// الجزء السفلي للواجهة الرئيسية يحتوي على شبكة الخيارات
class MainScreenBottomSection extends StatelessWidget {
  const MainScreenBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: mediaQuery.width,
        height: mediaQuery.height / 1.5,
        padding: Constants.sectionPadding,
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
            Text("welcome_to_app".tr(), style: Constants.titleTextStyle),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  MainScreenGridItem(
                    icon: Icons.book,
                    title: "my_lessons".tr(),
                    onTap: () {
                      context.pushReplacement(AppRouter.myLessonsScreenPath);
                      debugPrint('My Lessons tapped');
                    },
                  ),
                  MainScreenGridItem(
                    icon: Icons.person,
                    title: "my_teacher".tr(),
                    onTap: () {
                      context.push(AppRouter.gradeSelectionScreenPath);
                      debugPrint('My Teacher tapped');
                    },
                  ),
                  MainScreenGridItem(
                    icon: Icons.email,
                    title: "my_mail".tr(),
                    onTap: () {
                      debugPrint('My Mail tapped');
                    },
                  ),
                  MainScreenGridItem(
                    icon: Icons.check_circle,
                    title: "activate".tr(),
                    onTap: () {
                      context.push(AppRouter.activationScreenPath);
                      debugPrint('Activate tapped');
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