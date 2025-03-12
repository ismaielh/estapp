import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

// تعليق: شاشة الاختبار لقسم الدرس
class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const QuizScreen({super.key, required this.args});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int score = 0;
  List<Map<String, dynamic>> questions = [
    {
      'question': 'what_is_2_plus_2'.tr(),
      'options': ['3', '4', '5', '6'],
      'correctAnswer': '4',
    },
    {
      'question': 'capital_of_france'.tr(),
      'options': ['London', 'Paris', 'Berlin', 'Madrid'],
      'correctAnswer': 'Paris',
    },
    {
      'question': 'red_planet'.tr(),
      'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
      'correctAnswer': 'Mars',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;
    final section = widget.args['section'] as Section?;

    if (section == null || unit == null || lesson == null || subject == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'missing_required_data'.tr(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'quiz_title'.tr(),
          style: Constants.titleTextStyle.copyWith(
            color: Constants.backgroundColor,
          ),
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
            child: Padding(
              padding: Constants.sectionPadding,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          'quiz_title'.tr(),
                          style: Constants.activationTitleTextStyle,
                        ),
                        const SizedBox(
                          height: Constants.smallSpacingForLessons,
                        ),
                        ...List.generate(questions.length, (i) {
                          return Column(
                            children: [
                              Text(
                                questions[i]['question']!,
                                style: Constants.activationSubTextStyle,
                              ),
                              ...List.generate(4, (j) {
                                return RadioListTile<String>(
                                  title: Text(
                                    questions[i]['options']![j],
                                    style: Constants.activationSubTextStyle,
                                  ),
                                  value: questions[i]['options']![j],
                                  groupValue:
                                      questions[i]['selectedAnswer'] ?? '',
                                  onChanged: (value) {
                                    setState(() {
                                      questions[i]['selectedAnswer'] = value;
                                    });
                                  },
                                  activeColor: Constants.activeColor,
                                );
                              }),
                              const SizedBox(height: 10),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      int correctAnswers = 0;
                      for (var q in questions) {
                        if (q['selectedAnswer'] == q['correctAnswer']) {
                          correctAnswers++;
                        }
                      }
                      score =
                          ((correctAnswers / questions.length) * 100).toInt();
                      developer.log('Quiz score: $score');

                      if (score >= 60) {
                        context.read<LessonsCubit>().completeSection(
                          unit.id,
                          lesson.id,
                          section.id,
                        );
                        developer.log(
                          'Completed section ${section.id}, score: $score',
                        );

                        final currentIndex = lesson.sections.indexWhere(
                          (s) => s.id == section.id,
                        );
                        final nextIndex = currentIndex + 1;

                        if (nextIndex < lesson.sections.length) {
                          final nextSection = lesson.sections[nextIndex];
                          if (!nextSection.isActivated) {
                            context.read<LessonsCubit>().activateSection(
                              unit.id,
                              lesson.id,
                              nextSection.id,
                            );
                            developer.log(
                              'Activated next section ${nextSection.id}',
                            );
                          }
                        }
                        context.pop(true); // إرجاع true للنجاح
                      } else {
                        // تعليق: عودة إلى الفيديو إذا رسب
                        context.pushReplacement(
                          '/lesson-section/${section.id}',
                          extra: {
                            'subject': subject,
                            'unit': unit,
                            'lesson': lesson,
                            'section': section,
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: Constants.buttonPadding,
                    ),
                    child: Text(
                      'end_quiz'.tr(),
                      style: Constants.buttonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
