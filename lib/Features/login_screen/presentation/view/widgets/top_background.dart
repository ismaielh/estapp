import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';

// مكون الخلفية العلوية لصفحة تسجيل الدخول
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
          height: mediaQuery.height / Constants.topSectionHeightRatioForLogin,
          decoration: const BoxDecoration(color: Constants.backgroundColor),
        ),
        // الخلفية البنفسجية العلوية مع الصورة والمنحنى
        Container(
          width: mediaQuery.width,
          height: mediaQuery.height / Constants.topSectionHeightRatioForLogin,
          decoration: const BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Constants.borderRadiusBottom),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 50),
              Image.asset(
                Constants.booksImage,
                scale: Constants.iconScale - 0.15,
                errorBuilder: (context, error, stackTrace) {
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
