import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'language_dropdown.dart';
import 'get_started_button.dart';

// مكون الجزء السفلي كـ StatelessWidget
class BottomSection extends StatelessWidget {
  final String selectedLanguage;
  final Function(String?) onLanguageChanged;

  const BottomSection({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: mediaQuery.width,
        height: mediaQuery.height / Constants.bottomSectionHeightRatio,
        decoration: const BoxDecoration(color: Constants.primaryColor),
        child: Container(
          width: mediaQuery.width,
          height: mediaQuery.height / Constants.bottomSectionHeightRatio,
          padding: Constants.sectionPadding,
          decoration: const BoxDecoration(
            color: Constants.backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constants.borderRadiusBottom),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "learning_is_everything".tr(),
                style: Constants.subTitleTextStyle,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "learning_with_pleasure".tr(),
                  textAlign: TextAlign.center,
                  style: Constants.descriptionTextStyle,
                ),
              ),
              const SizedBox(height: 10),
              LanguageDropdown(
                selectedLanguage: selectedLanguage,
                onChanged: onLanguageChanged,
              ),
              const SizedBox(height: 10),
              GetStartedButton(selectedLanguage: selectedLanguage),
            ],
          ),
        ),
      ),
    );
  }
}
