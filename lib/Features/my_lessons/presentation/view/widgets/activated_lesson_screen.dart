import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class ActivatedLessonScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const ActivatedLessonScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final subject = args['subject'] as Subject;
    final unit = args['unit'] as Unit;
    final lesson = args['lesson'] as Lesson;

    return Scaffold(
      appBar: AppBarWidget(lesson: lesson),
      body: Stack(
        children: [
          const GradientBackground(),
          SectionsContent(subject: subject, unit: unit, lesson: lesson),
        ],
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Lesson lesson;

  const AppBarWidget({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${'lesson'.tr()} ${lesson.title}', // "الدرس 1" (ar) أو "Lesson 1" (en)
        style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor),
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

class SectionsContent extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;

  const SectionsContent({super.key, required this.subject, required this.unit, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                const SectionsHeader(),
                SectionsList(subject: subject, unit: unit, lesson: updatedLesson),
              ],
            );
          }
          return const LoadingIndicator();
        },
      ),
    );
  }
}

class SectionsHeader extends StatelessWidget {
  const SectionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.sectionPadding,
      child: Text(
        'sections_title'.tr(), // "الأقسام" (ar) أو "Sections" (en)
        style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor, fontSize: 24),
      ),
    );
  }
}

class SectionsList extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;

  const SectionsList({super.key, required this.subject, required this.unit, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
        itemCount: lesson.sections.length,
        itemBuilder: (context, index) {
          final section = lesson.sections[index];
          final isSectionLocked = _isSectionLocked(index, lesson.sections);
          developer.log('Section $index: isActivated: ${section.isActivated}, isCompleted: ${section.isCompleted}, isLocked: $isSectionLocked');
          return SectionItem(
            subject: subject,
            unit: unit,
            lesson: lesson,
            section: section,
            isSectionLocked: isSectionLocked,
          );
        },
      ),
    );
  }

  bool _isSectionLocked(int sectionIndex, List<Section> sections) {
    if (sectionIndex == 0) return false;
    for (int i = 0; i < sectionIndex; i++) {
      final previousSection = sections[i];
      if (previousSection.isActivated && !previousSection.isCompleted) return true;
    }
    return false;
  }
}

class SectionItem extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final Section section;
  final bool isSectionLocked;

  const SectionItem({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.section,
    required this.isSectionLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.cardElevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
      color: isSectionLocked ? Constants.cardBackgroundColor.withOpacity(0.5) : Constants.cardBackgroundColor,
      child: ListTile(
        title: Text(
          section.title, // عنوان القسم: مثل "Introduction"
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
            ? () => _navigateToSection(context)
            : null,
      ),
    );
  }

  void _navigateToSection(BuildContext context) {
    context.push(
      '/lesson-section/${section.id}',
      extra: {'subject': subject, 'unit': unit, 'lesson': lesson, 'section': section},
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}