import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

class LessonDetailScreen extends StatelessWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'lesson_detail'.tr(),
          style: Constants.titleTextStyle,
        ),
        backgroundColor: Constants.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Constants.primaryColor, Constants.backgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'lesson_id'.tr(args: [lessonId]),
                  style: Constants.subjectTextStyle,
                ),
                const SizedBox(height: Constants.mediumSpacingForLogin),
                Text(
                  'lesson_content'.tr(),
                  style: Constants.descriptionTextStyle,
                ),
                const SizedBox(height: Constants.largeSpacingForLogin),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    padding: Constants.buttonPadding,
                  ),
                  child: Text(
                    'back'.tr(),
                    style: Constants.buttonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}