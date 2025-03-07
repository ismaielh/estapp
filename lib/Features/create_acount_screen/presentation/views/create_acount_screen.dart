import 'package:estapps/Features/create_acount_screen/presentation/views/widgets/bottom_section.dart';
import 'package:estapps/Features/create_acount_screen/presentation/views/widgets/top_background.dart';
import 'package:flutter/material.dart';

// تعريف صفحة إنشاء الحساب كـ StatelessWidget
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: mediaQuery.width,
        height: mediaQuery.height,
        child: const Stack(children: [TopBackground(), BottomSection()]),
      ),
    );
  }
}
