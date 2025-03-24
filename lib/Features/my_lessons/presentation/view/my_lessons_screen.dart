// lib/Features/my_lessons/presentation/view/my_lessons_screen.dart
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:estapps/Features/my_lessons/data/models/subject.dart';
import 'dart:developer' as developer;

// تعليق: شاشة "دروسي" الرئيسية، تستخدم StatefulWidget فقط لإدارة دورة حياة LessonsCubit
class MyLessonsScreen extends StatefulWidget {
  const MyLessonsScreen({super.key});

  @override
  State<MyLessonsScreen> createState() => _MyLessonsScreenState();
}

class _MyLessonsScreenState extends State<MyLessonsScreen> {
  late final LessonsCubit _lessonsCubit;

  // تعليق: تهيئة LessonsCubit وتحميل المواد عند فتح الصفحة
  @override
  void initState() {
    super.initState();
    _lessonsCubit = LessonsCubit()..loadSubjects();
  }

  // تعليق: إغلاق LessonsCubit عند خروج المستخدم من الصفحة لتحسين الأداء
  @override
  void dispose() {
    _lessonsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _lessonsCubit,
      child: const Scaffold(
        body: Stack(
          children: [
            GradientBackground(), // تعليق: خلفية تدرجية لتحسين الجمالية
            MainContent(), // تعليق: المحتوى الرئيسي للشاشة
          ],
        ),
      ),
    );
  }
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

// تعليق: ويدجت لعرض المحتوى الرئيسي، يحتوي على العنوان وقسم المواد
class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          ScreenHeader(), // تعليق: عنوان الشاشة
          SubjectsSection(), // تعليق: قسم عرض المواد
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض عنوان الشاشة مترجم
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.sectionPadding,
      child: Text(
        'my_lessons_title'.tr(), // تعليق: "دروسي" (ar) أو "My Lessons" (en)
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 30,
          shadows: const [Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
    );
  }
}

// تعليق: ويدجت لعرض قسم المواد بناءً على حالة LessonsCubit
class SubjectsSection extends StatelessWidget {
  const SubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => const LoadingIndicator(), // تعليق: عرض مؤشر التحميل
            LessonsLoaded(subjects: var subjects) => SubjectsGrid(subjects: subjects), // تعليق: عرض شبكة المواد
            LessonsError(message: var message) => ErrorMessage(message: message), // تعليق: عرض رسالة خطأ
            _ => const EmptyMessage(), // تعليق: عرض رسالة عند عدم وجود حالة صالحة
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

// تعليق: ويدجت لعرض شبكة المواد في تخطيط شبكي
class SubjectsGrid extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectsGrid({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    developer.log('Subjects loaded: ${subjects.length}');
    if (subjects.isEmpty) return const EmptyMessage();
    return GridView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Constants.smallSpacingForLessons,
        mainAxisSpacing: Constants.smallSpacingForLessons,
        childAspectRatio: 1.2,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) => SubjectItem(subject: subjects[index]),
    );
  }
}

// تعليق: ويدجت لعرض عنصر مادة فردي مع إمكانية النقر للانتقال إلى الوحدات
class SubjectItem extends StatelessWidget {
  final Subject subject;

  const SubjectItem({super.key, required this.subject});

  // تعليق: دالة للانتقال إلى شاشة الوحدات مع تمرير البيانات عبر GoRouter
  void _navigateToUnits(BuildContext context) {
    try {
      final lessonsCubit = context.read<LessonsCubit>();
      developer.log('Navigating to /my-lessons/units/${subject.id}');
      context.push('/my-lessons/units/${subject.id}', extra: {'subject': subject, 'lessonsCubit': lessonsCubit});
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4)),
      color: Colors.white.withOpacity(0.95),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: () => _navigateToUnits(context),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
        child: SubjectContent(subject: subject),
      ),
    );
  }
}

// تعليق: ويدجت لعرض محتوى المادة (أيقونة وعنوان)
class SubjectContent extends StatelessWidget {
  final Subject subject;

  const SubjectContent({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SubjectIcon(subject: subject),
          const SizedBox(height: Constants.smallSpacingForLessons),
          SubjectTitle(subject: subject),
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض أيقونة المادة داخل دائرة
class SubjectIcon extends StatelessWidget {
  final Subject subject;

  const SubjectIcon({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Constants.primaryColor.withOpacity(0.1),
      child: Icon(
        subject.icon ?? Icons.book,
        size: 40.0,
        color: Constants.primaryColor,
      ),
    );
  }
}

// تعليق: ويدجت لعرض عنوان المادة مع تنسيق النص
class SubjectTitle extends StatelessWidget {
  final Subject subject;

  const SubjectTitle({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Text(
      subject.title,
      style: Constants.subjectTextStyle.copyWith(
        color: Constants.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// تعليق: ويدجت لعرض رسالة خطأ عند فشل تحميل المواد
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

// تعليق: ويدجت لعرض رسالة عند عدم وجود مواد متاحة
class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no_subjects_available'.tr(), // تعليق: "لا توجد مواد متاحة" (ar) أو "No subjects available" (en)
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}