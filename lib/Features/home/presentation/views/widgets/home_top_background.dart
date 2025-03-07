import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';

// مكون الخلفية العلوية كـ StatelessWidget
class TopBackground extends StatelessWidget {
  const TopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;

    return Stack(
      children: [
        // الخلفية البيضاء العلوية
        Container(
          width: mediaQuery.width,
          height: mediaQuery.height / Constants.topSectionHeightRatio,
          decoration: const BoxDecoration(color: Constants.backgroundColor),
        ),
        // الخلفية البنفسجية العلوية مع الصورة والمنحنى
        Container(
          width: mediaQuery.width,
          height: mediaQuery.height / Constants.topSectionHeightRatio,
          decoration: const BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Constants.borderRadiusTop),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image.asset(
                Constants.booksImage, // صورة الكتب في الخلفية
                scale: Constants.iconScale,
                errorBuilder: (context, error, stackTrace) {
                  // معالجة الحالة إذا فشل تحميل الصورة
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
