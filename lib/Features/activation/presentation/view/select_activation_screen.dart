import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

// تعليق: شاشة اختيار التفعيل لتحديد المادة والوحدة والدرس المراد تفعيله
class SelectActivationScreen extends StatefulWidget {
  const SelectActivationScreen({super.key});

  @override
  _SelectActivationScreenState createState() => _SelectActivationScreenState();
}

class _SelectActivationScreenState extends State<SelectActivationScreen> {
  Subject? selectedSubject;
  Unit? selectedUnit;
  Lesson? selectedLesson;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select_activation'.tr(),
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
            child: Padding(
              padding: Constants.sectionPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'select_subject'.tr(),
                      style: Constants.activationTitleTextStyle,
                    ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    Card(
                      elevation: Constants.activationCardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                      ),
                      color: Constants.cardBackgroundColor.withOpacity(0.9),
                      child: Padding(
                        padding: EdgeInsets.all(Constants.activationCardPadding),
                        child: BlocBuilder<LessonsCubit, LessonsState>(
                          builder: (context, state) {
                            if (state is LessonsLoaded) {
                              final subjects = state.subjects;
                              return DropdownButton<Subject>(
                                isExpanded: true,
                                value: selectedSubject,
                                hint: Text(
                                  'choose_subject'.tr(),
                                  style: Constants.activationSubTextStyle,
                                ),
                                dropdownColor: Constants.cardBackgroundColor,
                                items: subjects.map((Subject subject) {
                                  return DropdownMenuItem<Subject>(
                                    value: subject,
                                    child: Text(
                                      subject.title,
                                      style: Constants.activationSubTextStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Subject? newValue) {
                                  setState(() {
                                    selectedSubject = newValue;
                                    selectedUnit = null;
                                    selectedLesson = null;
                                  });
                                },
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    if (selectedSubject != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select_unit'.tr(),
                            style: Constants.activationTitleTextStyle,
                          ),
                          const SizedBox(height: Constants.smallSpacingForLessons),
                          Card(
                            elevation: Constants.activationCardElevation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                            ),
                            color: Constants.cardBackgroundColor.withOpacity(0.9),
                            child: Padding(
                              padding: EdgeInsets.all(Constants.activationCardPadding),
                              child: DropdownButton<Unit>(
                                isExpanded: true,
                                value: selectedUnit,
                                hint: Text(
                                  'choose_unit'.tr(),
                                  style: Constants.activationSubTextStyle,
                                ),
                                dropdownColor: Constants.cardBackgroundColor,
                                items: selectedSubject!.units.map((Unit unit) {
                                  return DropdownMenuItem<Unit>(
                                    value: unit,
                                    child: Text(
                                      unit.title,
                                      style: Constants.activationSubTextStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Unit? newValue) {
                                  setState(() {
                                    selectedUnit = newValue;
                                    selectedLesson = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    if (selectedUnit != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'select_lesson'.tr(),
                            style: Constants.activationTitleTextStyle,
                          ),
                          const SizedBox(height: Constants.smallSpacingForLessons),
                          Card(
                            elevation: Constants.activationCardElevation,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                            ),
                            color: Constants.cardBackgroundColor.withOpacity(0.9),
                            child: Padding(
                              padding: EdgeInsets.all(Constants.activationCardPadding),
                              child: DropdownButton<Lesson>(
                                isExpanded: true,
                                value: selectedLesson,
                                hint: Text(
                                  'choose_lesson'.tr(),
                                  style: Constants.activationSubTextStyle,
                                ),
                                dropdownColor: Constants.cardBackgroundColor,
                                items: selectedUnit!.lessons.map((Lesson lesson) {
                                  return DropdownMenuItem<Lesson>(
                                    value: lesson,
                                    child: Text(
                                      lesson.title,
                                      style: Constants.activationSubTextStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Lesson? newValue) {
                                  setState(() {
                                    selectedLesson = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    ElevatedButton(
                      onPressed: (selectedSubject == null || selectedUnit == null)
                          ? null
                          : () {
                              final args = {
                                'subject': selectedSubject,
                                'unit': selectedUnit,
                                'lesson': selectedLesson,
                              };
                              context.push('/activation', extra: args);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: Constants.buttonPadding,
                        disabledBackgroundColor: Constants.inactiveColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                        ),
                      ),
                      child: Text(
                        'next'.tr(),
                        style: Constants.buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}