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
          const GradientBackground(),
          const MainContent(),
        ],
      ),
    );
  }
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

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const ScreenHeader(),
          const SubjectsSection(),
        ],
      ),
    );
  }
}

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.sectionPadding,
      child: Text(
        'my_lessons_title'.tr(), // عنوان الشاشة: "دروسي" (ar) أو "My Lessons" (en)
        style: Constants.titleTextStyle.copyWith(
          color: Colors.white,
          fontSize: 30,
          shadows: const [Shadow(color: Colors.black26, offset: Offset(2, 2), blurRadius: 4)],
        ),
      ),
    );
  }
}

class SubjectsSection extends StatelessWidget {
  const SubjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => const LoadingIndicator(),
            LessonsLoaded(subjects: var subjects) => SubjectsGrid(subjects: subjects),
            LessonsError(message: var message) => ErrorMessage(message: message),
            _ => const EmptyMessage(),
          };
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
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Constants.activeColor)),
    );
  }
}

class SubjectsGrid extends StatelessWidget {
  final List<Subject> subjects;

  const SubjectsGrid({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
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
      itemBuilder: (context, index) => SubjectItem(subject: subjects[index]),
    );
  }
}

class SubjectItem extends StatelessWidget {
  final Subject subject;

  const SubjectItem({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    developer.log('Processing subject: ${subject.title}, units: ${subject.units.length}');
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4)),
      color: Colors.white.withOpacity(0.95),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: () => _navigateToUnits(context, subject),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
        child: SubjectContent(subject: subject),
      ),
    );
  }

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
}

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

class SubjectTitle extends StatelessWidget {
  final Subject subject;

  const SubjectTitle({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Text(
      subject.title, // عنوان المادة: مثل "Mathematics" أو ترجمتها
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

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message, // رسالة الخطأ: يجب أن تكون مترجمة في ملفات الترجمة
        style: Constants.descriptionTextStyle.copyWith(color: Constants.errorColorForCreateAccount),
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
        'no_subjects_available'.tr(), // "لا توجد مواد متاحة" (ar) أو "No subjects available" (en)
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}