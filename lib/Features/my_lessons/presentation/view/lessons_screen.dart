import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class LessonsScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const LessonsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final subject = args['subject'] as Subject?;
    final unit = args['unit'] as Unit?;
    if (subject == null || unit == null) {
      developer.log('LessonsScreen: Invalid subject or unit data');
      return const InvalidDataOverlay();
    }
    return Scaffold(
      appBar: AppBarWidget(subject: subject, unit: unit),
      body: Stack(
        children: [
          const GradientBackground(),
          MainContent(subject: subject, unit: unit),
        ],
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Subject subject;
  final Unit unit;

  const AppBarWidget({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${'unit'.tr()} ${unit.title}', // "الوحدة 1" (ar) أو "Unit 1" (en)
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 24,
          shadows: const [
            Shadow(color: Colors.black26, offset: Offset(1, 1), blurRadius: 3),
          ],
        ),
      ),
      backgroundColor: Constants.primaryColor.withOpacity(0.9),
      elevation: 4,
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
          'invalid_unit_data'
              .tr(), // "بيانات الوحدة غير صالحة" (ar) أو "Invalid unit data" (en)
          style: const TextStyle(
            color: Colors.red,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final Subject subject;
  final Unit unit;

  const MainContent({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SectionHeader(),
          LessonsList(subject: subject, unit: unit),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.sectionPadding,
      child: Text(
        'lessons_title'.tr(), // "الدروس" (ar) أو "Lessons" (en)
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 26,
          shadows: const [
            Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4),
          ],
        ),
      ),
    );
  }
}

class LessonsList extends StatelessWidget {
  final Subject subject;
  final Unit unit;

  const LessonsList({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          if (state is LessonsLoading) return const LoadingIndicator();
          if (state is LessonsLoaded) {
            final updatedUnit = state.subjects
                .expand((s) => s.units)
                .firstWhere((u) => u.id == unit.id, orElse: () => unit);
            final lessons = updatedUnit.lessons;
            if (lessons.isEmpty) return const EmptyMessage();
            return ListView.builder(
              padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                final isLessonActivated = lesson.isActivated;
                developer.log(
                  'LessonsScreen: Lesson ${lesson.title} activated: $isLessonActivated, sections: ${lesson.sections.length}',
                );
                return LessonItem(
                  subject: subject,
                  unit: unit,
                  lesson: lesson,
                  isLessonActivated: isLessonActivated,
                );
              },
            );
          }
          if (state is LessonsError)
            return ErrorMessage(message: state.message);
          return const EmptyMessage();
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Constants.activeColor),
      ),
    );
  }
}

class LessonItem extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final bool isLessonActivated;

  const LessonItem({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.isLessonActivated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: Constants.smallSpacingForLessons,
      ),
      elevation: isLessonActivated ? 8.0 : 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
      ),
      color:
          isLessonActivated
              ? Colors.white.withOpacity(0.9)
              : Colors.white.withOpacity(0.5),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: () => _navigate(context),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
        child: LessonContent(
          subject: subject,
          lesson: lesson,
          isActivated: isLessonActivated,
        ),
      ),
    );
  }

  void _navigate(BuildContext context) {
    if (!isLessonActivated) {
      context.push(
        '/activation',
        extra: {'subject': subject, 'unit': unit, 'lesson': lesson},
      );
    } else {
      developer.log('Navigating to activated lesson ${lesson.id}');
      context.push(
        '/activated-lesson/${lesson.id}',
        extra: {'subject': subject, 'unit': unit, 'lesson': lesson},
      );
    }
  }
}

class LessonContent extends StatelessWidget {
  final Subject subject;
  final Lesson lesson;
  final bool isActivated;

  const LessonContent({
    super.key,
    required this.subject,
    required this.lesson,
    required this.isActivated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.cardPadding,
      child: Row(
        children: [
          LessonIcon(subject: subject, isActivated: isActivated),
          const SizedBox(width: Constants.smallSpacingForLessons),
          Expanded(
            child: LessonTitle(lesson: lesson, isActivated: isActivated),
          ),
        ],
      ),
    );
  }
}

class LessonIcon extends StatelessWidget {
  final Subject subject;
  final bool isActivated;

  const LessonIcon({
    super.key,
    required this.subject,
    required this.isActivated,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Constants.primaryColor.withOpacity(
        isActivated ? 0.2 : 0.1,
      ),
      child: Icon(
        subject.icon ?? Icons.book,
        size: 30.0,
        color: isActivated ? Constants.activeColor : Constants.primaryColor,
      ),
    );
  }
}

class LessonTitle extends StatelessWidget {
  final Lesson lesson;
  final bool isActivated;

  const LessonTitle({
    super.key,
    required this.lesson,
    required this.isActivated,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${'lesson'.tr()} ${lesson.title}', // "الدرس 1" (ar) أو "Lesson 1" (en)
      style:
          isActivated
              ? Constants.activeTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
              : Constants.subjectTextStyle.copyWith(
                color: Constants.primaryColor,
              ),
      textAlign: TextAlign.start,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message, // رسالة الخطأ: يجب أن تكون مترجمة
        style: Constants.descriptionTextStyle.copyWith(
          color: Constants.errorColorForCreateAccount,
        ),
      ),
    );
  }
}

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no_lessons_available'
            .tr(), // "لا توجد دروس متاحة" (ar) أو "No lessons available" (en)
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}
