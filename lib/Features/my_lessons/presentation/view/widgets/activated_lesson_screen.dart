import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ActivatedLessonScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const ActivatedLessonScreen({super.key, required this.args});

  @override
  _ActivatedLessonScreenState createState() => _ActivatedLessonScreenState();
}

class _ActivatedLessonScreenState extends State<ActivatedLessonScreen> {
  int currentSectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject;
    final unit = widget.args['unit'] as Unit;
    final lesson = widget.args['lesson'] as Lesson;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${'lesson'.tr()} ${lesson.title}",
          style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor),
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: Constants.sectionPadding,
                  child: Text(
                    'sections_title'.tr(),
                    style: Constants.titleTextStyle.copyWith(
                      color: Constants.backgroundColor,
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
                    itemCount: lesson.sections.length,
                    itemBuilder: (context, index) {
                      final section = lesson.sections[index];
                      return Card(
                        elevation: Constants.cardElevation,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                        ),
                        color: Constants.cardBackgroundColor,
                        child: ListTile(
                          title: Text(
                            section.title,
                            style: section.isActivated
                                ? (section.isCompleted
                                    ? Constants.lessonTextStyle
                                    : Constants.activeTextStyle)
                                : Constants.lessonTextStyle,
                          ),
                          leading: Icon(
                            Icons.video_library,
                            color: section.isActivated
                                ? (section.isCompleted
                                    ? Constants.inactiveColor
                                    : Constants.activeColor)
                                : Constants.inactiveColor,
                          ),
                          onTap: section.isActivated && !section.isCompleted
                              ? () {
                                  _showVideo(context, section);
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVideo(BuildContext context, Section section) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(section.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Video Placeholder'), // استبدل بمشغل فيديو حقيقي لاحقاً
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showQuiz(context, section);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primaryColor,
                padding: Constants.buttonPadding,
              ),
              child: Text('end_viewing'.tr(), style: Constants.buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuiz(BuildContext context, Section section) {
    int score = 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('quiz_title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Question 1: Sample Question?'),
            RadioListTile<int>(
              title: const Text('Option 1'),
              value: 1,
              groupValue: score,
              onChanged: (value) => setState(() => score = value ?? 0),
            ),
            RadioListTile<int>(
              title: const Text('Option 2'),
              value: 2,
              groupValue: score,
              onChanged: (value) => setState(() => score = value ?? 0),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (score > 0) {
                context.read<LessonsCubit>().completeSection(
                      widget.args['unit'].id,
                      widget.args['lesson'].id,
                      section.id,
                    );
                if (score < 60) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('retry'.tr()),
                      content: Text('retry_message'.tr()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('ok'.tr()),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Constants.primaryColor,
              padding: Constants.buttonPadding,
            ),
            child: Text('end_quiz'.tr(), style: Constants.buttonTextStyle),
          ),
        ],
      ),
    );
  }
}