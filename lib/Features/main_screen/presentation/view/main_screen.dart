import 'package:estapps/Features/main_screen/presentation/view/widgets/main_screen_bottom_section.dart';
import 'package:estapps/Features/main_screen/presentation/view/widgets/main_screen_top_background.dart';

import 'package:flutter/material.dart';

// الواجهة الرئيسية بعد تسجيل الدخول
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: mediaQuery.width,
        height: mediaQuery.height,
        child: const Stack(
          children: [
            MainScreenTopBackground(),
            MainScreenBottomSection(),
          ],
        ),
      ),
    );
  }
}