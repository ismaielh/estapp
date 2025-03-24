import 'package:estapps/Features/my_lessons/data/models/subject.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class QuizScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const QuizScreen({super.key, required this.args});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
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
  final Map<int, String> _selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;
    final section = widget.args['section'] as Section?;

    if (section == null || unit == null || lesson == null || subject == null) {
      return const InvalidDataOverlay();
    }

    return Scaffold(
      appBar: AppBarWidget(),
      body: Stack(
        children: [
          const GradientBackground(),
          QuizContent(
            questions: questions,
            selectedAnswers: _selectedAnswers,
            onAnswerChanged: (index, value) {
              setState(() {
                _selectedAnswers[index] = value;
              });
            },
            subject: subject,
            unit: unit,
            lesson: lesson,
            section: section,
            onEndQuiz: _handleEndQuiz,
          ),
        ],
      ),
    );
  }

  void _handleEndQuiz(
    BuildContext context,
    Subject subject,
    Unit unit,
    Lesson lesson,
    Section section,
  ) {
    // التحقق من أن جميع الأسئلة قد تمت الإجابة عليها
    if (_selectedAnswers.length != questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_answer_all_questions'.tr())),
      );
      return;
    }

    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i]['correctAnswer']) {
        correctAnswers++;
      }
    }
    score = ((correctAnswers / questions.length) * 100).toInt();
    developer.log('Quiz score: $score');

    if (score >= 60) {
      context.read<LessonsCubit>().completeSection(
        unit.id,
        lesson.id,
        section.id,
      );
      developer.log('Completed section ${section.id}, score: $score');

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
          developer.log('Activated next section ${nextSection.id}');
        }
      }

      final currentLessonIndex = unit.lessons.indexWhere(
        (l) => l.id == lesson.id,
      );
      if (currentLessonIndex < unit.lessons.length - 1) {
        final nextLesson = unit.lessons[currentLessonIndex + 1];
        if (!nextLesson.isActivated) {
          context.read<LessonsCubit>().activateLesson(unit.id, nextLesson.id);
          developer.log('Activated next lesson ${nextLesson.id}');
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('quiz_passed_score'.tr(args: [score.toString()])),
        ),
      );
      context.pop(true); // إرجاع نتيجة النجاح
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('quiz_failed_score'.tr(args: [score.toString()])),
        ),
      );
      context.pop(false); // إرجاع نتيجة الرسوب
    }
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'quiz_title'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Constants.backgroundColor,
        ),
      ),
      backgroundColor: Constants.primaryColor.withOpacity(0.9),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.primaryColor.withOpacity(0.9),
            Constants.primaryColor.withOpacity(0.5),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.1, 1.0],
        ),
      ),
    );
  }
}

class InvalidDataOverlay extends StatelessWidget {
  const InvalidDataOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'missing_required_data'.tr(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class QuizContent extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Map<int, String> selectedAnswers;
  final Function(int, String) onAnswerChanged; // دالة لتحديث الإجابات
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final Section section;
  final void Function(BuildContext, Subject, Unit, Lesson, Section) onEndQuiz;

  const QuizContent({
    super.key,
    required this.questions,
    required this.selectedAnswers,
    required this.onAnswerChanged,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.section,
    required this.onEndQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  const SizedBox(height: Constants.smallSpacingForLessons),
                  ...List.generate(questions.length, (index) {
                    return QuestionWidget(
                      question: questions[index],
                      index: index,
                      selectedAnswer: selectedAnswers[index],
                      onChanged: (value) {
                        onAnswerChanged(
                          index,
                          value,
                        ); // تحديث الإجابة باستخدام الدالة
                      },
                    );
                  }),
                ],
              ),
            ),
            EndQuizButton(
              onPressed:
                  () => onEndQuiz(context, subject, unit, lesson, section),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final int index;
  final String? selectedAnswer;
  final ValueChanged<String> onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.index,
    required this.selectedAnswer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(question['question']!, style: Constants.activationSubTextStyle),
        ...List.generate(4, (j) {
          return RadioListTile<String>(
            title: Text(
              question['options']![j],
              style: Constants.activationSubTextStyle,
            ),
            value: question['options']![j],
            groupValue: selectedAnswer ?? '',
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            activeColor: Constants.activeColor,
          );
        }),
        const SizedBox(height: 10),
      ],
    );
  }
}

class EndQuizButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EndQuizButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.primaryColor,
        padding: Constants.buttonPadding,
      ),
      child: Text('end_quiz'.tr(), style: Constants.buttonTextStyle),
    );
  }
}
