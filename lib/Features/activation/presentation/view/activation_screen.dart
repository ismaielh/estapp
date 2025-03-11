import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ActivationScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const ActivationScreen({super.key, required this.args});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String? selectedPackageType = 'lesson'; // Default: lesson
  String? selectedLessonId;
  String? selectedUnitId;
  String? selectedSubjectId;
  final double lessonPrice = 10.0; // سعر الدرس الثابت (يمكن تعديله)
  double totalPrice = 0.0;
  final LessonsCubit _lessonsCubit = LessonsCubit();

  @override
  void initState() {
    super.initState();
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    selectedSubjectId = subject?.id;
    selectedUnitId = unit?.id;
    _lessonsCubit = context.read<LessonsCubit>(); // الحصول على الـ Cubit من السياق
    calculatePrice();
  }

  void calculatePrice() {
    if (selectedPackageType == 'lesson' && selectedLessonId != null) {
      totalPrice = lessonPrice;
    } else if (selectedPackageType == 'unit' && selectedUnitId != null) {
      final unit = _lessonsCubit.state.subjects
          .firstWhere((s) => s.id == selectedSubjectId)
          .units
          .firstWhere((u) => u.id == selectedUnitId);
      totalPrice = lessonPrice * unit.lessons.length;
    } else if (selectedPackageType == 'subject' && selectedSubjectId != null) {
      final subject = _lessonsCubit.state.subjects
          .firstWhere((s) => s.id == selectedSubjectId);
      totalPrice = lessonPrice *
          subject.units.fold<int>(0, (sum, unit) => sum + unit.lessons.length);
    } else {
      totalPrice = 0.0;
    }
    setState(() {});
  }

  void activatePurchase() {
    if (selectedPackageType == 'lesson' && selectedLessonId != null) {
      _lessonsCubit.activateLesson(selectedLessonId!);
    } else if (selectedPackageType == 'unit' && selectedUnitId != null) {
      final unit = _lessonsCubit.state.subjects
          .firstWhere((s) => s.id == selectedSubjectId)
          .units
          .firstWhere((u) => u.id == selectedUnitId);
      for (var lesson in unit.lessons) {
        _lessonsCubit.activateLesson(lesson.id);
      }
    } else if (selectedPackageType == 'subject' && selectedSubjectId != null) {
      final subject = _lessonsCubit.state.subjects
          .firstWhere((s) => s.id == selectedSubjectId);
      for (var unit in subject.units) {
        for (var lesson in unit.lessons) {
          _lessonsCubit.activateLesson(lesson.id);
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('success'.tr()),
        content: Text('activation_success_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject?;
    final unit = widget.args['unit'] as Unit?;
    final lessons = unit?.lessons ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('activate'.tr()),
        backgroundColor: Constants.primaryColor,
      ),
      body: Padding(
        padding: Constants.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedPackageType,
              items: ['lesson', 'unit', 'subject']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.tr()),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPackageType = value;
                  selectedLessonId = null;
                  selectedUnitId = null;
                  calculatePrice();
                });
              },
            ),
            if (selectedPackageType == 'lesson')
              Column(
                children: lessons.map((lesson) {
                  return RadioListTile<String>(
                    title: Text('lesson ${lesson.title}'),
                    value: lesson.id,
                    groupValue: selectedLessonId,
                    onChanged: (value) {
                      setState(() {
                        selectedLessonId = value;
                        calculatePrice();
                      });
                    },
                  );
                }).toList(),
              ),
            if (selectedPackageType == 'unit' && subject != null)
              Column(
                children: subject.units.map((unit) {
                  return RadioListTile<String>(
                    title: Text('unit ${unit.title}'),
                    value: unit.id,
                    groupValue: selectedUnitId,
                    onChanged: (value) {
                      setState(() {
                        selectedUnitId = value;
                        calculatePrice();
                      });
                    },
                  );
                }).toList(),
              ),
            if (selectedPackageType == 'subject' && subject != null)
              ListTile(
                title: Text('subject ${subject.title}'),
                onTap: () {
                  setState(() {
                    selectedSubjectId = subject.id;
                    calculatePrice();
                  });
                },
              ),
            SizedBox(height: 20),
            Text('total_price'.tr(args: [totalPrice.toStringAsFixed(2)])),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: totalPrice > 0 ? activatePurchase : null,
              child: Text('purchase'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}