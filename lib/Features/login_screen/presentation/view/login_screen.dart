import 'package:estapps/Features/login_screen/presentation/view/widgets/bottom_section.dart';
import 'package:estapps/Features/login_screen/presentation/view/widgets/top_background.dart';
import 'package:flutter/material.dart';

// تعريف صفحة تسجيل الدخول كـ StatelessWidget
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          width: mediaQuery.width,
          height: mediaQuery.height,
          child: const Stack(children: [TopBackground(), BottomSection()]),
        ),
      ),
    );
  }
}
