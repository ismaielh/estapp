import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ActivationScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const ActivationScreen({super.key, required this.args});

  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String? selectedPackage;
  List<Lesson> selectedLessons = [];
  double totalPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject;
    final unit = widget.args['unit'] as Unit;
    final lesson = widget.args['lesson'] as Lesson?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'activation_title'.tr(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'select_package'.tr(),
                    style: Constants.titleTextStyle.copyWith(
                      color: Constants.backgroundColor,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectedPackage,
                    hint: Text('choose_package'.tr()),
                    items:
                        ['Lesson', 'Unit', 'Curriculum'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPackage = newValue;
                        selectedLessons.clear();
                        totalPrice = 0.0;
                      });
                    },
                  ),
                  if (selectedPackage == 'Lesson' && lesson != null)
                    Column(
                      children: [
                        Text('select_lessons'.tr()),
                        ...unit.lessons.map(
                          (l) => CheckboxListTile(
                            title: Text("${'lesson'.tr()} ${l.title}"),
                            value: selectedLessons.contains(l),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedLessons.add(l);
                                } else {
                                  selectedLessons.remove(l);
                                }
                                totalPrice =
                                    selectedLessons.length *
                                    Constants.lessonPrice;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  if (selectedPackage == 'Unit')
                    Column(
                      children: [
                        Text('unit_price'.tr()),
                        Text(
                          '${unit.lessons.length * Constants.lessonPrice} ${'currency'.tr()}',
                        ),
                      ],
                    ),
                  if (selectedPackage == 'Curriculum')
                    Column(
                      children: [
                        Text('curriculum_price'.tr()),
                        Text(
                          '${subject.units.fold(0, (sum, u) => sum + u.lessons.length) * Constants.lessonPrice} ${'currency'.tr()}',
                        ),
                      ],
                    ),
                  Text('${'total_price'.tr()}: $totalPrice ${'currency'.tr()}'),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedPackage == 'Lesson' &&
                          selectedLessons.isNotEmpty) {
                        for (var lesson in selectedLessons) {
                          context.read<LessonsCubit>().activateLesson(
                            unit.id,
                            lesson.id,
                          );
                        }
                      } else if (selectedPackage == 'Unit') {
                        context.read<LessonsCubit>().activateUnit(unit.id);
                        for (var lesson in unit.lessons) {
                          context.read<LessonsCubit>().activateLesson(
                            unit.id,
                            lesson.id,
                          );
                        }
                      } else if (selectedPackage == 'Curriculum') {
                        for (var u in subject.units) {
                          context.read<LessonsCubit>().activateUnit(u.id);
                          for (var lesson in u.lessons) {
                            context.read<LessonsCubit>().activateLesson(
                              u.id,
                              lesson.id,
                            );
                          }
                        }
                      }
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('success'.tr()),
                              content: Text('activation_pending'.tr()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('ok'.tr()),
                                ),
                              ],
                            ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: Constants.buttonPadding,
                    ),
                    child: Text('pay'.tr(), style: Constants.buttonTextStyle),
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
