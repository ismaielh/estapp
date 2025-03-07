import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart'; // استيراد مكتبة go_router

// تعريف الصفحة الترحيبية كـ StatefulWidget لإدارة حالة اللغة
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _selectedLanguage = 'ar'; // اللغة الافتراضية هي العربية

  // دالة لتغيير اللغة عند اختيار قيمة جديدة من القائمة المنسدلة
  void _changeLanguage(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedLanguage = newValue;
        context.setLocale(Locale(newValue)); // تغيير اللغة ديناميكيًا
      });
    }
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
            Container(
              width: mediaQuery.width,
              height: mediaQuery.height / 1.6,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            Container(
              width: mediaQuery.width,
              height: mediaQuery.height / 1.6,
              decoration: const BoxDecoration(
                color: Color(0xff674AEF),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                ),
              ),
              child: Center(
                child: Image.asset("assets/images/books.png", scale: 0.8),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: mediaQuery.width,
                height: mediaQuery.height / 2.6,
                decoration: const BoxDecoration(color: Color(0xff674AEF)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: mediaQuery.width,
                height: mediaQuery.height / 2.600,
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ), // تقليل الحشوة
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // توزيع العناصر بشكل متساوٍ
                  children: [
                    Text(
                      "learning_is_everything".tr(),
                      style: const TextStyle(
                        fontSize: 20, // تقليل حجم النص
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8), // تقليل المسافة بين العناصر
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "learning_with_pleasure".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14, // تقليل حجم النص
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // تقليل المسافة
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      hint: Text("select_language".tr()),
                      items: [
                        DropdownMenuItem(value: 'en', child: Text('English')),
                        DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      ],
                      onChanged: _changeLanguage,
                    ),
                    const SizedBox(height: 10), // تقليل المسافة
                    Material(
                      color: const Color(0xff674AEF),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          // التنقل إلى الصفحة الرئيسية عند الضغط
                          context.go('/home');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 60,
                          ), // تقليل حجم الزر
                          child: Text(
                            "get_started".tr(),
                            style: const TextStyle(
                              fontSize: 18, // تقليل حجم النص
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
