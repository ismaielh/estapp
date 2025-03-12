import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

// تعليق: شاشة تفعيل الدروس مع خيارات الدفع
class ActivationScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const ActivationScreen({super.key, required this.args});

  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String? selectedPackage;
  List<Lesson> selectedLessons = [];
  String? selectedPaymentMethod = 'seritel_cash';
  double totalPrice = 0.0;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;

    if (lesson != null) {
      selectedPackage = 'Lesson';
      selectedLessons = [lesson];
    } else if (unit != null) {
      selectedPackage = 'Unit';
    } else if (subject != null) {
      selectedPackage = 'Curriculum';
    }
    calculatePrice();
  }

  void calculatePrice() {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;

    if (selectedPackage == 'Lesson' && selectedLessons.isNotEmpty) {
      totalPrice = selectedLessons.length * Constants.lessonPrice;
    } else if (selectedPackage == 'Unit' && unit != null) {
      totalPrice = unit.lessons.length * Constants.lessonPrice;
    } else if (selectedPackage == 'Curriculum' && subject != null) {
      totalPrice = subject.units.fold(0, (sum, u) => sum + u.lessons.length) * Constants.lessonPrice;
    } else {
      totalPrice = 0.0;
    }
    setState(() {});
  }

  void processPayment(Unit? unit, Subject? subject) {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    final selectedLessonsCopy = List<Lesson>.from(selectedLessons.isNotEmpty ? selectedLessons : unit?.lessons ?? []);
    Future.delayed(const Duration(seconds: 2), () {
      final cubit = context.read<LessonsCubit>();
      if (selectedPackage == 'Lesson' && selectedLessonsCopy.isNotEmpty) {
        for (var lesson in selectedLessonsCopy) {
          cubit.activateLesson(unit!.id, lesson.id);
          developer.log('Activated lesson: ${lesson.id}');
        }
      } else if (selectedPackage == 'Unit' && unit != null) {
        cubit.activateUnit(unit.id);
        for (var lesson in unit.lessons) {
          cubit.activateLesson(unit.id, lesson.id);
          developer.log('Activated lesson: ${lesson.id} in unit ${unit.id}');
        }
      } else if (selectedPackage == 'Curriculum' && subject != null) {
        for (var u in subject.units) {
          cubit.activateUnit(u.id);
          for (var lesson in u.lessons) {
            cubit.activateLesson(u.id, lesson.id);
            developer.log('Activated lesson: ${lesson.id} in unit ${u.id}');
          }
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('success'.tr(), style: Constants.activationTitleTextStyle),
          content: Text('activation_pending'.tr(), style: Constants.activationSubTextStyle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/lessons/${unit?.id ?? subject!.units.first.id}');
              },
              child: Text('ok'.tr(), style: Constants.activationSubTextStyle.copyWith(color: Constants.primaryColor)),
            ),
          ],
          backgroundColor: Constants.cardBackgroundColor,
        ),
      ).then((_) {
        if (mounted) {
          setState(() {
            isProcessing = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;

    return Scaffold(
      appBar: AppBar(
        title: Text('activation_title'.tr(), style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor)),
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
              padding: Constants.activationSectionPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('select_package'.tr(), style: Constants.activationTitleTextStyle),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    Card(
                      elevation: Constants.activationCardElevation,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                      color: Constants.cardBackgroundColor.withOpacity(0.9),
                      child: Padding(
                        padding: EdgeInsets.all(Constants.activationCardPadding),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedPackage,
                          hint: Text('choose_package'.tr(), style: Constants.activationSubTextStyle),
                          dropdownColor: Constants.cardBackgroundColor,
                          items: ['Lesson', 'Unit', 'Curriculum'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: Constants.activationSubTextStyle),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPackage = newValue;
                              if (newValue == 'Lesson' && lesson != null) {
                                selectedLessons = [lesson];
                              } else if (newValue == 'Unit' && unit != null) {
                                selectedLessons.clear();
                              } else if (newValue == 'Curriculum') {
                                selectedLessons.clear();
                              }
                              calculatePrice();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    if (selectedPackage == 'Lesson' && lesson != null)
                      Column(
                        children: [
                          Text('select_lessons'.tr(), style: Constants.activationTitleTextStyle),
                          const SizedBox(height: Constants.smallSpacingForLessons),
                          Card(
                            elevation: Constants.activationCardElevation,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                            color: Constants.cardBackgroundColor.withOpacity(0.9),
                            child: Padding(
                              padding: EdgeInsets.all(Constants.activationCardPadding),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return CheckboxListTile(
                                    title: Text('${'lesson'.tr()} ${lesson.title}', style: Constants.activationSubTextStyle),
                                    value: selectedLessons.contains(lesson),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedLessons = [lesson];
                                        } else {
                                          selectedLessons.clear();
                                        }
                                        calculatePrice();
                                      });
                                    },
                                    activeColor: Constants.activeColor,
                                    checkColor: Constants.backgroundColor,
                                    tileColor: Constants.cardBackgroundColor.withOpacity(0.95),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (selectedPackage == 'Unit' && unit != null)
                      Card(
                        elevation: Constants.activationCardElevation,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                        color: Constants.cardBackgroundColor.withOpacity(0.9),
                        child: Padding(
                          padding: EdgeInsets.all(Constants.activationCardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('unit_details'.tr(), style: Constants.activationTitleTextStyle),
                              const SizedBox(height: Constants.smallSpacingForLessons),
                              Text('${'unit'.tr()} ${unit.title}: ${unit.lessons.length} ${'lessons'.tr()}', style: Constants.activationSubTextStyle),
                              Text('${'unit_price'.tr()}: ${unit.lessons.length * Constants.lessonPrice} ${'currency'.tr()}', style: Constants.activationPriceTextStyle),
                            ],
                          ),
                        ),
                      ),
                    if (selectedPackage == 'Curriculum' && subject != null)
                      Card(
                        elevation: Constants.activationCardElevation,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                        color: Constants.cardBackgroundColor.withOpacity(0.9),
                        child: Padding(
                          padding: EdgeInsets.all(Constants.activationCardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('curriculum_details'.tr(), style: Constants.activationTitleTextStyle),
                              const SizedBox(height: Constants.smallSpacingForLessons),
                              Text('${'subject'.tr()} ${subject.title}: ${subject.units.fold(0, (sum, u) => sum + u.lessons.length)} ${'lessons'.tr()}', style: Constants.activationSubTextStyle),
                              Text('${'curriculum_price'.tr()}: ${subject.units.fold(0, (sum, u) => sum + u.lessons.length) * Constants.lessonPrice} ${'currency'.tr()}', style: Constants.activationPriceTextStyle),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    Card(
                      elevation: Constants.activationCardElevation,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                      color: Constants.cardBackgroundColor.withOpacity(0.9),
                      child: Padding(
                        padding: EdgeInsets.all(Constants.activationCardPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('payment_method'.tr(), style: Constants.activationTitleTextStyle),
                            const SizedBox(height: Constants.smallSpacingForLessons),
                            ListTile(
                              leading: Icon(Icons.payment, color: Constants.inactiveColor),
                              title: Text('seritel_cash'.tr(), style: Constants.activationSubTextStyle),
                              trailing: Radio<String>(
                                value: 'seritel_cash',
                                groupValue: selectedPaymentMethod,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedPaymentMethod = value;
                                  });
                                },
                                activeColor: Constants.activeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    Text('${'total_price'.tr()}: $totalPrice ${'currency'.tr()}', style: Constants.activationPriceTextStyle),
                    const SizedBox(height: Constants.smallSpacingForLessons),
                    ElevatedButton(
                      onPressed: isProcessing || totalPrice == 0.0 ? null : () {
                        processPayment(unit, subject);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        padding: Constants.buttonPadding,
                        disabledBackgroundColor: Constants.inactiveColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                      ),
                      child: isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('pay'.tr(), style: Constants.buttonTextStyle),
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