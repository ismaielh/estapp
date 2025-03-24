// lib/Features/my_lessons/presentation/view/lessons_screen.dart
import 'package:estapps/Features/my_lessons/data/models/subject.dart';

import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

// تعليق: شاشة الدروس لِوحدة معينة، تعرض قائمة الدروس مع إمكانية التنقل إلى التفعيل أو الدرس المفعل
class LessonsScreen extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final LessonsCubit lessonsCubit;

  const LessonsScreen({
    super.key,
    required this.subject,
    required this.unit,
    required this.lessonsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lessonsCubit, // تعليق: تمرير LessonsCubit الموجود لإدارة الحالة
      child: Scaffold(
        appBar: AppBarWidget(subject: subject, unit: unit),
        body: Stack(
          children: [
            const GradientBackground(), // تعليق: خلفية تدرجية لتحسين الشكل
            MainContent(subject: subject, unit: unit),
          ],
        ),
      ),
    );
  }
}

// تعليق: ويدجت لعرض شريط التطبيق مع عنوان المادة والوحدة
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Subject subject;
  final Unit unit;

  const AppBarWidget({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${subject.title} - ${'unit'.tr()} ${unit.title}',
        style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor),
      ),
      backgroundColor: Constants.primaryColor.withOpacity(0.9),
      elevation: 4,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// تعليق: ويدجت لعرض خلفية تدرجية تمتد عبر الشاشة
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.primaryColor.withOpacity(0.9),
            Constants.secondaryColor.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

// تعليق: ويدجت لعرض المحتوى الرئيسي، يحتوي على قسم الدروس
class MainContent extends StatelessWidget {
  final Subject subject;
  final Unit unit;

  const MainContent({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          LessonsSection(subject: subject, unit: unit), // تعليق: قسم عرض الدروس
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض قسم الدروس بناءً على حالة LessonsCubit
class LessonsSection extends StatelessWidget {
  final Subject subject;
  final Unit unit;

  const LessonsSection({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => const LoadingIndicator(), // تعليق: عرض مؤشر التحميل
            LessonsLoaded(subjects: var subjects) => LessonsList(
                subject: subject,
                unit: unit,
                lessons: subjects
                    .firstWhere((s) => s.id == subject.id)
                    .units
                    .firstWhere((u) => u.id == unit.id)
                    .lessons,
              ),
            LessonsError(message: var message) => ErrorMessage(message: message),
            _ => const EmptyMessage(), // تعليق: عرض رسالة إذا لم تكن الحالة صالحة
          };
        },
      ),
    );
  }
}

// تعليق: ويدجت لعرض مؤشر التحميل أثناء جلب البيانات
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

// تعليق: ويدجت لعرض قائمة الدروس في تخطيط عمودي
class LessonsList extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final List<Lesson> lessons;

  const LessonsList({
    super.key,
    required this.subject,
    required this.unit,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('Lessons loaded for unit ${unit.id}: ${lessons.length}');
    if (lessons.isEmpty) return const EmptyMessage();
    return ListView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      itemCount: lessons.length,
      itemBuilder: (context, index) => LessonItem(
        subject: subject,
        unit: unit,
        lesson: lessons[index],
      ),
    );
  }
}

// تعليق: ويدجت لعرض عنصر درس فردي مع إمكانية النقر للانتقال إلى الدرس أو التفعيل
class LessonItem extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;

  const LessonItem({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
  });

  // تعليق: دالة لتحديد التنقل بناءً على حالة تفعيل الدرس
  void _navigate(BuildContext context) {
    try {
      final lessonsCubit = context.read<LessonsCubit>();
      if (lesson.isActivated) {
        developer.log('Navigating to /my-lessons/activated-lesson/${lesson.id}');
        context.push(
          '/my-lessons/activated-lesson/${lesson.id}',
          extra: {
            'subject': subject,
            'unit': unit,
            'lesson': lesson,
            'lessonsCubit': lessonsCubit,
          },
        );
      } else {
        developer.log('Navigating to /my-lessons/activation for lesson ${lesson.id}');
        context.push(
          '/my-lessons/activation',
          extra: {
            'subject': subject,
            'unit': unit,
            'lesson': lesson,
            'lessonsCubit': lessonsCubit,
          },
        );
      }
      // إضافة خيار للتنقل إلى LessonSectionScreen إذا كان لديك قسم معين
      final section = lesson.sections?.first; // افتراض أن Lesson يحتوي على قائمة أقسام
      if (section != null && lesson.isActivated) {
        developer.log('Navigating to /my-lessons/lesson-section/${section.id}');
        context.push(
          '/my-lessons/lesson-section/${section.id}',
          extra: {
            'subject': subject,
            'unit': unit,
            'lesson': lesson,
            'section': section,
            'lessonsCubit': lessonsCubit,
          },
        );
      }
    } catch (e) {
      developer.log('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('navigation_error'.tr(args: [e.toString()]))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius)),
      color: Colors.white.withOpacity(0.95),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: Constants.smallSpacingForLessons / 2),
      child: InkWell(
        onTap: () => _navigate(context),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        child: LessonContent(lesson: lesson),
      ),
    );
  }
}

// تعليق: ويدجت لعرض محتوى الدرس (العنوان وحالة التفعيل)
class LessonContent extends StatelessWidget {
  final Lesson lesson;

  const LessonContent({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.cardPadding,
      child: Row(
        children: [
          LessonIcon(isActivated: lesson.isActivated),
          const SizedBox(width: Constants.smallSpacingForLessons),
          Expanded(child: LessonTitle(lesson: lesson)),
          ActivationStatus(isActivated: lesson.isActivated),
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض أيقونة الدرس بناءً على حالة التفعيل
class LessonIcon extends StatelessWidget {
  final bool isActivated;

  const LessonIcon({super.key, required this.isActivated});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActivated ? Constants.activeColor.withOpacity(0.2) : Constants.inactiveColor.withOpacity(0.2),
      child: Icon(
        isActivated ? Icons.check_circle : Icons.lock,
        color: isActivated ? Constants.activeColor : Constants.inactiveColor,
        size: 28,
      ),
    );
  }
}

// تعليق: ويدجت لعرض عنوان الدرس
class LessonTitle extends StatelessWidget {
  final Lesson lesson;

  const LessonTitle({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${'lesson'.tr()} ${lesson.title}',
      style: Constants.subjectTextStyle.copyWith(
        color: Constants.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// تعليق: ويدجت لعرض حالة تفعيل الدرس
class ActivationStatus extends StatelessWidget {
  final bool isActivated;

  const ActivationStatus({super.key, required this.isActivated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActivated ? Constants.activeColor : Constants.inactiveColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActivated ? 'activated'.tr() : 'locked'.tr(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

// تعليق: ويدجت لعرض رسالة خطأ عند فشل تحميل الدروس
class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Constants.descriptionTextStyle.copyWith(color: Constants.errorColorForCreateAccount),
      ),
    );
  }
}

// تعليق: ويدجت لعرض رسالة عند عدم وجود دروس متاحة
class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no_lessons_available'.tr(),
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}