import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';

// مكون الخلفية العلوية لصفحة إنشاء الحساب
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
          height:
              mediaQuery.height /
              Constants.topSectionHeightRatioForCreateAccount,
          decoration: const BoxDecoration(color: Constants.backgroundColor),
        ),
        // الخلفية البنفسجية العلوية مع الصورة والمنحنى
        Container(
          width: mediaQuery.width,
          height:
              mediaQuery.height /
              Constants.topSectionHeightRatioForCreateAccount,
          decoration: const BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Constants.borderRadiusBottom),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // رفع الصورة للأعلى
            children: [
              SizedBox(height: 40), // إضافة مسافة علوية صغيرة للتعديل
              Image.asset(
                Constants.booksImage,
                scale: Constants.iconScale,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.error,
                    color: Constants.errorColorForCreateAccount,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
