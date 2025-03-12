import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

class MyLessonsScreen extends StatelessWidget {
  const MyLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGradientBackground(), // تعليق: خلفية التدرج اللوني
          _buildMainContent(context), // تعليق: المحتوى الرئيسي للشاشة
        ],
      ),
    );
  }

  // تعليق: دالة لبناء خلفية التدرج اللوني مع تأثير قطري خفيف
  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Constants.primaryColor.withOpacity(0.9),
            Constants.backgroundColor.withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.9],
        ),
      ),
    );
  }

  // تعليق: دالة لبناء المحتوى الرئيسي مع منطقة آمنة
  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildScreenHeader(), // تعليق: العنوان العلوي للشاشة
          _buildSubjectsSection(context), // تعليق: قسم عرض المواد
        ],
      ),
    );
  }

  // تعليق: دالة لبناء العنوان العلوي مع نص مترجم وظل خفيف
  Widget _buildScreenHeader() {
    return Padding(
      padding: Constants.sectionPadding,
      child: Text(
        'my_lessons_title'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 30,
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

  // تعليق: دالة لبناء قسم المواد باستخدام BlocBuilder لإدارة الحالات
  Widget _buildSubjectsSection(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => _buildLoadingIndicator(), // تعليق: حالة التحميل
            LessonsLoaded(subjects: var subjects) => _buildSubjectsGrid(
              context,
              subjects,
            ), // تعليق: حالة عرض المواد
            LessonsError(message: var message) => _buildErrorMessage(
              message,
            ), // تعليق: حالة الخطأ
            _ => _buildEmptyMessage(), // تعليق: حالة عدم وجود بيانات
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

  // تعليق: دالة لبناء شبكة المواد عند تحميل البيانات بنجاح
  Widget _buildSubjectsGrid(BuildContext context, List<Subject> subjects) {
    developer.log('Subjects loaded: ${subjects.length}');
    return GridView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Constants.smallSpacingForLessons,
        mainAxisSpacing: Constants.smallSpacingForLessons,
        childAspectRatio: 1.2,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        developer.log(
          'Processing subject: ${subject.title}, units: ${subject.units.length}',
        );
        return _buildSubjectItem(context, subject); // تعليق: بناء عنصر المادة
      },
    );
  }

  // تعليق: دالة لبناء كرت المادة الواحدة مع أيقونة دائرية وتأثير النقر
  Widget _buildSubjectItem(BuildContext context, Subject subject) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
      ),
      color: Colors.white.withOpacity(0.95),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap:
            () => _navigateToUnits(
              context,
              subject,
            ), // تعليق: التنقل إلى شاشة الوحدات
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
        child: _buildSubjectContent(subject), // تعليق: محتوى الكرت
      ),
    );
  }

  // تعليق: دالة لبناء محتوى كرت المادة (أيقونة ونص)
  Widget _buildSubjectContent(Subject subject) {
    return Padding(
      padding: Constants.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSubjectIcon(subject), // تعليق: الأيقونة الدائرية
          const SizedBox(height: Constants.smallSpacingForLessons),
          _buildSubjectTitle(subject), // تعليق: عنوان المادة
        ],
      ),
    );
  }

  // تعليق: دالة لبناء الأيقونة الدائرية للمادة
  Widget _buildSubjectIcon(Subject subject) {
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

  // تعليق: دالة لبناء عنوان المادة مع تنسيق نصي محسّن
  Widget _buildSubjectTitle(Subject subject) {
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

  // تعليق: دالة لمعالجة التنقل إلى شاشة الوحدات مع التعامل مع الأخطاء
  void _navigateToUnits(BuildContext context, Subject subject) {
    try {
      developer.log('Navigating to /units/${subject.id}');
      context.push('/units/${subject.id}', extra: {'subject': subject});
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

  // تعليق: دالة لبناء رسالة في حالة عدم وجود مواد متاحة
  Widget _buildEmptyMessage() {
    return Center(
      child: Text(
        'no_subjects_available'.tr(),
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}
