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
        Container(
          width: mediaQuery.width,
          height: mediaQuery.height / Constants.topSectionHeightRatio,
          decoration: const BoxDecoration(color: Constants.backgroundColor),
        ),
        Container(
          width: mediaQuery.width,
          height: mediaQuery.height / Constants.topSectionHeightRatio,
          decoration: const BoxDecoration(
            color: Constants.primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Constants.borderRadiusTop),
            ),
          ),
          child: Center(
            child: Image.asset(
              Constants.booksImage,
              scale: Constants.iconScale,
            ),
          ),
        ),
      ],
    );
  }
}
