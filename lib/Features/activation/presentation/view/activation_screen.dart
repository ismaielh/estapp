import 'package:estapps/Features/my_lessons/data/models/subject.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // إضافة مكتبة awesome_dialog
import 'dart:developer' as developer;

// تعليق: شاشة تفعيل الدروس مع خيارات الدفع وتحسين سير اختيار المادة، الوحدات، والدروس
class ActivationScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const ActivationScreen({super.key, required this.args});

  @override
  _ActivationScreenState createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String? selectedSubjectId;
  String? selectedUnitId;
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

    if (subject != null) {
      selectedSubjectId = subject.id;
    } else if (unit != null) {
      final cubit = context.read<LessonsCubit>();
      if (cubit.state is LessonsLoaded) {
        final state = cubit.state as LessonsLoaded;
        final parentSubject = state.subjects.firstWhere(
          (s) => s.units.any((u) => u.id == unit.id),
          orElse: () => subject!,
        );
        selectedSubjectId = parentSubject.id;
        selectedUnitId = unit.id;
      }
    } else if (lesson != null) {
      final cubit = context.read<LessonsCubit>();
      if (cubit.state is LessonsLoaded) {
        final state = cubit.state as LessonsLoaded;
        final parentSubject = state.subjects.firstWhere(
          (s) => s.units.any((u) => u.lessons.any((l) => l.id == lesson.id)),
          orElse: () => subject!,
        );
        final parentUnit = parentSubject.units.firstWhere(
          (u) => u.lessons.any((l) => l.id == lesson.id),
          orElse: () => unit!,
        );
        selectedSubjectId = parentSubject.id;
        selectedUnitId = parentUnit.id;
        selectedLessons = [lesson];
      }
    }
    calculatePrice();
  }

  void calculatePrice() {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;

    if (selectedLessons.isNotEmpty) {
      totalPrice = selectedLessons.length * Constants.lessonPrice;
    } else if (selectedUnitId != null && unit != null) {
      totalPrice =
          unit.lessons.where((l) => !l.isActivated).length *
          Constants.lessonPrice;
    } else if (selectedSubjectId != null && subject != null) {
      totalPrice =
          subject.units.fold(
            0,
            (sum, u) => sum + u.lessons.where((l) => !l.isActivated).length,
          ) *
          Constants.lessonPrice;
    } else {
      totalPrice = 0.0;
    }
    setState(() {});
  }

  void processPayment() {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;
    final cubit = context.read<LessonsCubit>();

    try {
      if (selectedLessons.isNotEmpty) {
        final unitId = selectedUnitId ?? _findUnitIdForLesson(lesson!);
        for (var lesson in selectedLessons.where((l) => !l.isActivated)) {
          cubit.activateLesson(unitId!, lesson.id);
          developer.log('Activated lesson: ${lesson.id}');
        }
      } else if (selectedUnitId != null && unit != null) {
        cubit.activateUnit(unit.id);
        for (var lesson in unit.lessons.where((l) => !l.isActivated)) {
          cubit.activateLesson(unit.id, lesson.id);
          developer.log('Activated lesson: ${lesson.id} in unit ${unit.id}');
        }
      } else if (selectedSubjectId != null && subject != null) {
        for (var u in subject.units) {
          cubit.activateUnit(u.id);
          for (var lesson in u.lessons.where((l) => !l.isActivated)) {
            cubit.activateLesson(u.id, lesson.id);
            developer.log('Activated lesson: ${lesson.id} in unit ${u.id}');
          }
        }
      }

      _showSuccessDialog(unit?.id); // تمرير unitId كـ nextScreenId
    } catch (e) {
      developer.log('Payment processing error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('error_processing_payment'.tr(args: [e.toString()])),
        ),
      );
      setState(() {
        isProcessing = false;
      });
    }
  }

  String? _findUnitIdForLesson(Lesson lesson) {
    final cubit = context.read<LessonsCubit>();
    if (cubit.state is LessonsLoaded) {
      final state = cubit.state as LessonsLoaded;
      for (var subject in state.subjects) {
        for (var unit in subject.units) {
          if (unit.lessons.any((l) => l.id == lesson.id)) {
            return unit.id;
          }
        }
      }
    }
    return null;
  }

  void _showSuccessDialog(String? unitId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success, // نوع التنبيه (نجاح)
      animType: AnimType.scale, // نوع الرسوم المتحركة
      title: 'success'.tr(),
      desc: 'activation_pending'.tr(),
      btnOkText: 'ok'.tr(),
      btnOkColor: Constants.primaryColor,
      btnOkOnPress: () {
        final cubit = context.read<LessonsCubit>();
        if (unitId != null) {
          context.push(
            '/my-lessons/lessons/$unitId', // تعديل المسار ليتوافق مع AppRouter
            extra: {
              'subject': widget.args['subject'],
              'unit': widget.args['unit'],
              'lessonsCubit': cubit,
            },
          );
        } else {
          context.pop();
        }
      },
      dismissOnTouchOutside: false,
      padding: const EdgeInsets.all(20),
      btnOkIcon: Icons.check_circle,
      btnOk: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Constants.primaryColor,
          ), // تصحيح النوع
        ),
        onPressed: () {}, // يتم التعامل مع الضغط عبر btnOkOnPress
        child: Text('ok'.tr(), style: Constants.buttonTextStyle),
      ),
    ).show().then((_) {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lesson = widget.args['lesson'] as Lesson?;

    if (subject == null && unit == null && lesson == null) {
      return const _InvalidDataOverlay();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'activation_title'.tr(),
          style: Constants.titleTextStyle.copyWith(
            color: Constants.backgroundColor,
          ),
        ),
        backgroundColor: Constants.primaryColor.withOpacity(0.9),
        elevation: 4,
      ),
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            child: Padding(
              padding: Constants.activationSectionPadding,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSubjectSelection(subject),
                    if (selectedSubjectId != null) _buildUnitSelection(subject),
                    if (selectedUnitId != null) _buildLessonSelection(unit),
                    if (selectedLessons.isNotEmpty ||
                        selectedUnitId != null ||
                        selectedSubjectId != null)
                      _buildPaymentSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelection(Subject? subject) {
    final cubit = context.read<LessonsCubit>();
    final state =
        cubit.state is LessonsLoaded ? (cubit.state as LessonsLoaded) : null;
    final subjects = state?.subjects ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('select_subject'.tr(), style: Constants.activationTitleTextStyle),
        const SizedBox(height: Constants.smallSpacingForLessons),
        Card(
          elevation: Constants.activationCardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          ),
          color: Constants.cardBackgroundColor.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(Constants.activationCardPadding),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedSubjectId,
              hint: Text(
                'choose_subject'.tr(),
                style: Constants.activationSubTextStyle,
              ),
              dropdownColor: Constants.cardBackgroundColor,
              items:
                  subjects.map((Subject value) {
                    return DropdownMenuItem<String>(
                      value: value.id,
                      child: Text(
                        value.title,
                        style: Constants.activationSubTextStyle,
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSubjectId = newValue;
                  selectedUnitId = null;
                  selectedLessons.clear();
                  calculatePrice();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUnitSelection(Subject? subject) {
    final cubit = context.read<LessonsCubit>();
    final state = cubit.state as LessonsLoaded;
    final selectedSubject = state.subjects.firstWhere(
      (s) => s.id == selectedSubjectId,
    );
    final units = selectedSubject.units;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Constants.smallSpacingForLessons),
        Text('select_unit'.tr(), style: Constants.activationTitleTextStyle),
        const SizedBox(height: Constants.smallSpacingForLessons),
        Card(
          elevation: Constants.activationCardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          ),
          color: Constants.cardBackgroundColor.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(Constants.activationCardPadding),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedUnitId,
              hint: Text(
                'choose_unit'.tr(),
                style: Constants.activationSubTextStyle,
              ),
              dropdownColor: Constants.cardBackgroundColor,
              items:
                  units.map((Unit value) {
                    return DropdownMenuItem<String>(
                      value: value.id,
                      child: Text(
                        value.title,
                        style: Constants.activationSubTextStyle,
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUnitId = newValue;
                  selectedLessons.clear();
                  calculatePrice();
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonSelection(Unit? unit) {
    final cubit = context.read<LessonsCubit>();
    final state = cubit.state as LessonsLoaded;
    final selectedSubject = state.subjects.firstWhere(
      (s) => s.id == selectedSubjectId,
    );
    final selectedUnit = selectedSubject.units.firstWhere(
      (u) => u.id == selectedUnitId,
    );
    final lessons =
        selectedUnit.lessons
            .where((l) => !l.isActivated)
            .toList(); // عرض الدروس غير المفعلة فقط

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Constants.smallSpacingForLessons),
        Text('select_lessons'.tr(), style: Constants.activationTitleTextStyle),
        const SizedBox(height: Constants.smallSpacingForLessons),
        Card(
          elevation: Constants.activationCardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          ),
          color: Constants.cardBackgroundColor.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(Constants.activationCardPadding),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return CheckboxListTile(
                  title: Text(
                    '${'lesson'.tr()} ${lesson.title}',
                    style: Constants.activationSubTextStyle,
                  ),
                  value: selectedLessons.contains(lesson),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedLessons.add(lesson);
                      } else {
                        selectedLessons.remove(lesson);
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
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Constants.smallSpacingForLessons),
        Card(
          elevation: Constants.activationCardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
          ),
          color: Constants.cardBackgroundColor.withOpacity(0.9),
          child: Padding(
            padding: EdgeInsets.all(Constants.activationCardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'payment_method'.tr(),
                  style: Constants.activationTitleTextStyle,
                ),
                const SizedBox(height: Constants.smallSpacingForLessons),
                ListTile(
                  leading: Icon(Icons.payment, color: Constants.inactiveColor),
                  title: Text(
                    'seritel_cash'.tr(),
                    style: Constants.activationSubTextStyle,
                  ),
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
        Text(
          '${'total_price'.tr()}: $totalPrice ${'currency'.tr()}',
          style: Constants.activationPriceTextStyle,
        ),
        const SizedBox(height: Constants.smallSpacingForLessons),
        ElevatedButton(
          onPressed: isProcessing || totalPrice == 0.0 ? null : processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.primaryColor,
            padding: Constants.buttonPadding,
            disabledBackgroundColor: Constants.inactiveColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
            ),
          ),
          child:
              isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('pay'.tr(), style: Constants.buttonTextStyle),
        ),
      ],
    );
  }
}

class _InvalidDataOverlay extends StatelessWidget {
  const _InvalidDataOverlay();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'missing_required_data'.tr(),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
