import 'package:estapps/Features/welcom_screen/presentation/views/widgets/bottom_section.dart';
import 'package:estapps/Features/welcom_screen/presentation/views/widgets/top_background.dart';
import 'package:estapps/core/util/function/functions.dart';
import 'package:flutter/material.dart';


// تعريف الصفحة الترحيبية كـ StatefulWidget لإدارة حالة اللغة
class WelcomeScreenBody extends StatefulWidget {
  const WelcomeScreenBody({super.key});

  @override
  _WelcomeScreenBodyState createState() => _WelcomeScreenBodyState();
}

class _WelcomeScreenBodyState extends State<WelcomeScreenBody> {
  String _selectedLanguage = 'ar'; // اللغة الافتراضية هي العربية

  // دالة لتغيير اللغة (استخدام دالة من functions.dart)
  void _changeLanguage(String? newValue) {
    Functions.changeLanguage(context, newValue, (value) => setState(() => _selectedLanguage = value));
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Material(
      child: SizedBox(
        width: mediaQuery.width,
        height: mediaQuery.height,
        child: Stack(
          children: [
            const TopBackground(), // الخلفية العلوية
            BottomSection(
              selectedLanguage: _selectedLanguage,
              onLanguageChanged: _changeLanguage,
            ), // تمرير اللغة ودالة التغيير
          ],
        ),
      ),
    );
  }
}