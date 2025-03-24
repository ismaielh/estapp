// lib/Features/my_lessons/presentation/view/units_screen.dart
import 'package:estapps/Features/my_lessons/data/models/subject.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

// تعليق: شاشة الوحدات لمادة معينة، تعرض قائمة الوحدات مع حالة التفعيل بناءً على الدروس
class UnitsScreen extends StatelessWidget {
  final Subject subject;
  final LessonsCubit lessonsCubit;

  const UnitsScreen({
    super.key,
    required this.subject,
    required this.lessonsCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: lessonsCubit, // تعليق: تمرير LessonsCubit الموجود لإدارة الحالة
      child: Scaffold(
        appBar: AppBarWidget(subject: subject),
        body: Stack(
          children: [
            const GradientBackground(), // تعليق: خلفية تدرجية لتحسين الشكل
            MainContent(subject: subject),
          ],
        ),
      ),
    );
  }
}

// تعليق: ويدجت لعرض شريط التطبيق بعنوان المادة
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Subject subject;

  const AppBarWidget({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${'subject'.tr()} ${subject.title}',
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

// تعليق: ويدجت لعرض المحتوى الرئيسي، يحتوي على قسم الوحدات
class MainContent extends StatelessWidget {
  final Subject subject;

  const MainContent({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          UnitsSection(subject: subject), // تعليق: قسم عرض الوحدات
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض قسم الوحدات بناءً على حالة LessonsCubit
class UnitsSection extends StatelessWidget {
  final Subject subject;

  const UnitsSection({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => const LoadingIndicator(), // تعليق: عرض مؤشر التحميل
            LessonsLoaded(subjects: var subjects) => UnitsList(
                subject: subject,
                units: subjects.firstWhere((s) => s.id == subject.id).units,
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

// تعليق: ويدجت لعرض قائمة الوحدات في تخطيط عمودي
class UnitsList extends StatelessWidget {
  final Subject subject;
  final List<Unit> units;

  const UnitsList({super.key, required this.subject, required this.units});

  @override
  Widget build(BuildContext context) {
    developer.log('Units loaded for subject ${subject.id}: ${units.length}');
    if (units.isEmpty) return const EmptyMessage();
    return ListView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      itemCount: units.length,
      itemBuilder: (context, index) => UnitItem(subject: subject, unit: units[index]),
    );
  }
}

// تعليق: ويدجت لعرض عنصر وحدة فردي مع إمكانية النقر للانتقال إلى الدروس
class UnitItem extends StatelessWidget {
  final Subject subject;
  final Unit unit;

  const UnitItem({super.key, required this.subject, required this.unit});

  // تعليق: التحقق مما إذا كان هناك درس واحد على الأقل مفعل داخل الوحدة
  bool get _hasActivatedLesson => unit.lessons.any((lesson) => lesson.isActivated);

  // تعليق: دالة للانتقال إلى شاشة الدروس مع تمرير البيانات
  void _navigateToLessons(BuildContext context) {
    try {
      final lessonsCubit = context.read<LessonsCubit>();
      developer.log('Navigating to /my-lessons/lessons/${unit.id}');
      context.push(
        '/my-lessons/lessons/${unit.id}',
        extra: {
          'subject': subject,
          'unit': unit,
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
      // تعليق: لون باهت إذا لم يكن هناك دروس مفعلة، لون عادي إذا كان هناك درس مفعل
      color: _hasActivatedLesson ? Colors.white.withOpacity(0.95) : Colors.grey.withOpacity(0.5),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: Constants.smallSpacingForLessons / 2),
      child: InkWell(
        onTap: () => _navigateToLessons(context),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
        child: UnitContent(unit: unit, isActivated: _hasActivatedLesson),
      ),
    );
  }
}

// تعليق: ويدجت لعرض محتوى الوحدة (العنوان وحالة التفعيل)
class UnitContent extends StatelessWidget {
  final Unit unit;
  final bool isActivated; // تعليق: تعتمد على وجود دروس مفعلة

  const UnitContent({super.key, required this.unit, required this.isActivated});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.cardPadding,
      child: Row(
        children: [
          UnitIcon(isActivated: isActivated),
          const SizedBox(width: Constants.smallSpacingForLessons),
          Expanded(child: UnitTitle(unit: unit)),
          ActivationStatus(isActivated: isActivated),
        ],
      ),
    );
  }
}

// تعليق: ويدجت لعرض أيقونة الوحدة بناءً على حالة التفعيل
class UnitIcon extends StatelessWidget {
  final bool isActivated;

  const UnitIcon({super.key, required this.isActivated});

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

// تعليق: ويدجت لعرض عنوان الوحدة
class UnitTitle extends StatelessWidget {
  final Unit unit;

  const UnitTitle({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${'unit'.tr()} ${unit.title}',
      style: Constants.subjectTextStyle.copyWith(
        color: Constants.primaryColor,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

// تعليق: ويدجت لعرض حالة تفعيل الوحدة
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

// تعليق: ويدجت لعرض رسالة خطأ عند فشل تحميل الوحدات
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

// تعليق: ويدجت لعرض رسالة عند عدم وجود وحدات متاحة
class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'no_units_available'.tr(),
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}