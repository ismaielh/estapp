// lib/Features/my_lessons/presentation/view/widgets/activated_lesson_screen.dart
import 'package:estapps/Features/my_lessons/data/models/subject.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

// تعليق: شاشة الدرس المفعّل، تعرض الأقسام المتاحة لدرس معين
class ActivatedLessonScreen extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final LessonsCubit lessonsCubit;

  const ActivatedLessonScreen({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.lessonsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lessonsCubit, // تعليق: تمرير LessonsCubit الموجود إلى الشاشة
      child: Scaffold(
        appBar: AppBarWidget(subject: subject, unit: unit, lesson: lesson),
        body: Stack(
          children: [
            const GradientBackground(), // تعليق: خلفية تدرجية للجمالية
            MainContent(subject: subject, unit: unit, lesson: lesson),
          ],
        ),
      ),
    );
  }
}

// تعليق: ويدجت لعرض شريط التطبيق مع عنوان المادة، الوحدة، والدرس
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;

  const AppBarWidget({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${subject.title} - ${'unit'.tr()} ${unit.title} - ${'lesson'.tr()} ${lesson.title}',
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

// تعليق: ويدجت لعرض المحتوى الرئيسي، يحتوي على قسم الأقسام
class MainContent extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;

  const MainContent({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SectionsSection(subject: subject, unit: unit, lesson: lesson), // تعليق: قسم عرض الأقسام
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض قسم الأقسام بناءً على حالة LessonsCubit
class SectionsSection extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;

  const SectionsSection({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => const LoadingIndicator(), // تعليق: عرض مؤشر التحميل
            LessonsLoaded(subjects: var subjects) => SectionsList(
                subject: subject,
                unit: unit,
                lesson: lesson,
                sections: subjects
                    .firstWhere((s) => s.id == subject.id)
                    .units
                    .firstWhere((u) => u.id == unit.id)
                    .lessons
                    .firstWhere((l) => l.id == lesson.id)
                    .sections,
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

// تعليق: ويدجت لعرض قائمة الأقسام في تخطيط عمودي
class SectionsList extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final List<Section> sections;

  const SectionsList({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('Sections loaded for lesson ${lesson.id}: ${sections.length}');
    if (sections.isEmpty) return const EmptyMessage();
    return ListView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      itemCount: sections.length,
      itemBuilder: (context, index) => SectionItem(
        subject: subject,
        unit: unit,
        lesson: lesson,
        section: sections[index],
      ),
    );
  }
}

// تعليق: ويدجت لعرض عنصر قسم فردي مع إمكانية النقر للانتقال إلى محتوى القسم
class SectionItem extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final Section section;

  const SectionItem({
    super.key,
    required this.subject,
    required this.unit,
    required this.lesson,
    required this.section,
  });

  // تعليق: دالة للانتقال إلى شاشة قسم الدرس إذا كان مفعلاً
  void _navigateToSection(BuildContext context) {
    if (!section.isActivated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('section_not_activated'.tr())),
      );
      return;
    }
    try {
      final lessonsCubit = context.read<LessonsCubit>();
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
        onTap: () => _navigateToSection(context),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        child: SectionContent(section: section),
      ),
    );
  }
}

// تعليق: ويدجت لعرض محتوى القسم (العنوان وحالة التفعيل/الإكمال)
class SectionContent extends StatelessWidget {
  final Section section;

  const SectionContent({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.cardPadding,
      child: Row(
        children: [
          SectionIcon(isActivated: section.isActivated, isCompleted: section.isCompleted),
          const SizedBox(width: Constants.smallSpacingForLessons),
          Expanded(child: SectionTitle(section: section)),
          SectionStatus(isActivated: section.isActivated, isCompleted: section.isCompleted),
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض أيقونة القسم بناءً على حالة التفعيل والإكمال
class SectionIcon extends StatelessWidget {
  final bool isActivated;
  final bool isCompleted;

  const SectionIcon({super.key, required this.isActivated, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isCompleted
          ? Constants.activeColor.withOpacity(0.2)
          : isActivated
              ? Constants.primaryColor.withOpacity(0.2)
              : Constants.inactiveColor.withOpacity(0.2),
      child: Icon(
        isCompleted
            ? Icons.done_all
            : isActivated
                ? Icons.play_circle
                : Icons.lock,
        color: isCompleted
            ? Constants.activeColor
            : isActivated
                ? Constants.primaryColor
                : Constants.inactiveColor,
        size: 28,
      ),
    );
  }
}

// تعليق: ويدجت لعرض عنوان القسم
class SectionTitle extends StatelessWidget {
  final Section section;

  const SectionTitle({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${'section'.tr()} ${section.title}',
      style: Constants.subjectTextStyle.copyWith(
        color: Constants.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// تعليق: ويدجت لعرض حالة القسم (مفعل، مكتمل، أو مقفل)
class SectionStatus extends StatelessWidget {
  final bool isActivated;
  final bool isCompleted;

  const SectionStatus({super.key, required this.isActivated, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? Constants.activeColor
            : isActivated
                ? Constants.primaryColor
                : Constants.inactiveColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isCompleted
            ? 'completed'.tr()
            : isActivated
                ? 'activated'.tr()
                : 'locked'.tr(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

// تعليق: ويدجت لعرض رسالة خطأ عند فشل تحميل الأقسام
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

// تعليق: ويدجت لعرض رسالة عند عدم وجود أقسام متاحة
class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no_sections_available'.tr(), // تعليق: "لا توجد أقسام متاحة" (ar) أو "No sections available" (en)
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}