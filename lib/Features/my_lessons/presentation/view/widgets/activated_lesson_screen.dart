import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/Features/my_lessons/presentation/view/lesson_section_screen.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer' as developer;

// تعليق: شاشة عرض الدروس المفعلة مع قوائم الأقسام
class ActivatedLessonScreen extends StatefulWidget {
  final Map<String, dynamic> args;

  const ActivatedLessonScreen({super.key, required this.args});

  @override
  _ActivatedLessonScreenState createState() => _ActivatedLessonScreenState();
}

class _ActivatedLessonScreenState extends State<ActivatedLessonScreen> {
  @override
  void initState() {
    super.initState();
    developer.log('ActivatedLessonScreen: Initializing for lesson ${widget.args['lesson'].id}');
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.args['subject'] as Subject;
    final unit = widget.args['unit'] as Unit;
    final lesson = widget.args['lesson'] as Lesson;

    return Scaffold(
      appBar: AppBar(
        title: Text('${'lesson'.tr()} ${lesson.title}', style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor)),
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
            child: BlocBuilder<LessonsCubit, LessonsState>(
              builder: (context, state) {
                if (state is LessonsLoaded) {
                  final updatedLesson = state.subjects
                      .expand((s) => s.units)
                      .expand((u) => u.lessons)
                      .firstWhere((l) => l.id == lesson.id, orElse: () => lesson);

                  if (updatedLesson.sections.isEmpty) {
                    return Center(child: Text('no_sections'.tr(), style: Constants.activationTitleTextStyle));
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: Constants.sectionPadding,
                        child: Text('sections_title'.tr(), style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor, fontSize: 24)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
                          itemCount: updatedLesson.sections.length,
                          itemBuilder: (context, index) {
                            final section = updatedLesson.sections[index];
                            final isSectionLocked = _isSectionLocked(index, updatedLesson.sections);
                            developer.log('Section $index: isActivated: ${section.isActivated}, isCompleted: ${section.isCompleted}, isLocked: $isSectionLocked');
                            return Card(
                              elevation: Constants.cardElevation,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
                              color: isSectionLocked ? Constants.cardBackgroundColor.withOpacity(0.5) : Constants.cardBackgroundColor,
                              child: ListTile(
                                title: Text(
                                  section.title,
                                  style: section.isActivated
                                      ? (section.isCompleted ? Constants.lessonTextStyle : Constants.activeTextStyle)
                                      : Constants.lessonTextStyle.copyWith(color: isSectionLocked ? Colors.grey : null),
                                ),
                                leading: Icon(
                                  isSectionLocked ? Icons.lock : Icons.video_library,
                                  color: section.isActivated
                                      ? (section.isCompleted ? Constants.inactiveColor : Constants.activeColor)
                                      : Constants.inactiveColor,
                                ),
                                onTap: (section.isActivated && !section.isCompleted && !isSectionLocked)
                                    ? () {
                                        context.push(
                                          '/lesson-section/${section.id}',
                                          extra: {
                                            'subject': subject,
                                            'unit': unit,
                                            'lesson': updatedLesson,
                                            'section': section,
                                          },
                                        ).then((_) {
                                          if (mounted) setState(() {});
                                        });
                                      }
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isSectionLocked(int sectionIndex, List<Section> sections) {
    if (sectionIndex == 0) return false;
    for (int i = 0; i < sectionIndex; i++) {
      final previousSection = sections[i];
      if (previousSection.isActivated && !previousSection.isCompleted) {
        return true;
      }
    }
    return false;
  }
}