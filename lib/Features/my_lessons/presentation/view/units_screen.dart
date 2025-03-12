import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class UnitsScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const UnitsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final subject = args['subject'] as Subject?;
    // تعليق: التحقق من صحة بيانات المادة
    return Scaffold(
      appBar: _buildAppBar(subject), // تعليق: شريط التطبيق مع عنوان المادة
      body: Stack(
        children: [
          _buildGradientBackground(), // تعليق: خلفية التدرج اللوني
          subject == null
              ? _buildInvalidDataOverlay(
                context,
              ) // تعليق: طبقة عرض بيانات غير صالحة
              : _buildMainContent(context, subject), // تعليق: المحتوى الرئيسي
        ],
      ),
    );
  }

  // تعليق: دالة لبناء شريط التطبيق مع نوع PreferredSizeWidget
  PreferredSizeWidget _buildAppBar(Subject? subject) {
    return AppBar(
      title: Text(
        subject?.title ?? 'units_title'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 24,
          shadows: [
            const Shadow(
              color: Colors.black26,
              offset: Offset(1, 1),
              blurRadius: 3,
            ),
          ],
        ),
      ),
      backgroundColor: Constants.primaryColor.withOpacity(0.9),
      elevation: 4,
    );
  }

  // تعليق: دالة لبناء خلفية التدرج اللوني مع تأثير ناعم
  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.primaryColor.withOpacity(0.85),
            Constants.backgroundColor.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.2, 0.95],
        ),
      ),
    );
  }

  // تعليق: دالة لبناء طبقة عرض بيانات غير صالحة
  Widget _buildInvalidDataOverlay(BuildContext context) {
    developer.log('UnitsScreen: Invalid subject data');
    return Center(
      child: Text(
        'invalid_subject_data'.tr(),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // تعليق: دالة لبناء المحتوى الرئيسي مع منطقة آمنة
  Widget _buildMainContent(BuildContext context, Subject subject) {
    return SafeArea(
      child: Column(
        children: [
          _buildSectionHeader(), // تعليق: العنوان الفرعي للوحدات
          _buildUnitsGrid(context, subject), // تعليق: شبكة الوحدات
        ],
      ),
    );
  }

  // تعليق: دالة لبناء العنوان الفرعي لقسم الوحدات
  Widget _buildSectionHeader() {
    return Padding(
      padding: Constants.sectionPadding,
      child: Text(
        'units_title'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 26,
          shadows: [
            const Shadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  // تعليق: دالة لبناء شبكة الوحدات باستخدام BlocBuilder
  Widget _buildUnitsGrid(BuildContext context, Subject subject) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => _buildLoadingIndicator(), // تعليق: حالة التحميل
            LessonsLoaded(subjects: var subjects) => _buildLoadedUnits(
              context,
              subject,
              subjects,
            ), // تعليق: حالة العرض
            LessonsError(message: var message) => _buildErrorMessage(
              message,
            ), // تعليق: حالة الخطأ
            _ => _buildEmptyMessage(), // تعليق: حالة عدم وجود وحدات
          };
        },
      ),
    );
  }

  // تعليق: دالة لبناء مؤشر التحميل أثناء جلب البيانات
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Constants.activeColor),
      ),
    );
  }

  // تعليق: دالة لبناء شبكة الوحدات عند تحميل البيانات بنجاح
  Widget _buildLoadedUnits(
    BuildContext context,
    Subject subject,
    List<Subject> subjects,
  ) {
    final updatedSubject = subjects.firstWhere(
      (s) => s.id == subject.id,
      orElse: () => subject,
    );
    final units = updatedSubject.units;
    developer.log(
      'UnitsScreen: Units loaded for ${subject.title}: ${units.length}',
    );
    if (units.isEmpty) {
      return _buildEmptyMessage();
    }
    return GridView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Constants.smallSpacingForLessons,
        mainAxisSpacing: Constants.smallSpacingForLessons,
        childAspectRatio: 1.2,
      ),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return _buildUnitItem(context, subject, unit); // تعليق: بناء كرت الوحدة
      },
    );
  }

  // تعليق: دالة لبناء كرت الوحدة الواحدة مع تأثير تفعيل
  Widget _buildUnitItem(BuildContext context, Subject subject, Unit unit) {
    final isUnitActivated = unit.lessons.any((lesson) => lesson.isActivated);
    developer.log(
      'UnitsScreen: Building unit card: ${unit.title}, activated: $isUnitActivated',
    );
    return Card(
      elevation: isUnitActivated ? 8.0 : 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
      ),
      color: isUnitActivated ? Colors.white : Colors.white.withOpacity(0.9),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap:
            () => _navigateToLessons(
              context,
              subject,
              unit,
            ), // تعليق: التنقل إلى الدروس
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
        child: _buildUnitContent(
          subject,
          unit,
          isUnitActivated,
        ), // تعليق: محتوى الكرت
      ),
    );
  }

  // تعليق: دالة لبناء محتوى كرت الوحدة (أيقونة ونص)
  Widget _buildUnitContent(Subject subject, Unit unit, bool isActivated) {
    return Padding(
      padding: Constants.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUnitIcon(subject, isActivated), // تعليق: الأيقونة الدائرية
          const SizedBox(height: Constants.smallSpacingForLessons),
          _buildUnitTitle(unit, isActivated), // تعليق: عنوان الوحدة
        ],
      ),
    );
  }

  // تعليق: دالة لبناء الأيقونة الدائرية للوحدة مع تغيير اللون حسب التفعيل
  Widget _buildUnitIcon(Subject subject, bool isActivated) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Constants.primaryColor.withOpacity(
        isActivated ? 0.2 : 0.1,
      ),
      child: Icon(
        subject.icon ?? Icons.book,
        size: 40.0,
        color: isActivated ? Constants.activeColor : Constants.primaryColor,
      ),
    );
  }

  // تعليق: دالة لبناء عنوان الوحدة مع ترجمة وتنسيق حسب التفعيل
  Widget _buildUnitTitle(Unit unit, bool isActivated) {
    return Text(
      '${'unit'.tr()} ${unit.title}',
      style:
          isActivated
              ? Constants.activeTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
              : Constants.subjectTextStyle.copyWith(
                color: Constants.primaryColor,
              ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // تعليق: دالة لمعالجة التنقل إلى شاشة الدروس مع التعامل مع الأخطاء
  void _navigateToLessons(BuildContext context, Subject subject, Unit unit) {
    try {
      developer.log('UnitsScreen: Navigating to /lessons/${unit.id}');
      context.push(
        '/lessons/${unit.id}',
        extra: {'subject': subject, 'unit': unit},
      );
    } catch (e) {
      developer.log('Navigation error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('navigation_error'.tr(args: [e.toString()]))),
      );
    }
  }

  // تعليق: دالة لبناء رسالة الخطأ في حالة فشل تحميل البيانات
  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: Constants.descriptionTextStyle.copyWith(
          color: Constants.errorColorForCreateAccount,
        ),
      ),
    );
  }

  // تعليق: دالة لبناء رسالة في حالة عدم وجود وحدات متاحة
  Widget _buildEmptyMessage() {
    return Center(
      child: Text(
        'no_units_available'.tr(),
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}
