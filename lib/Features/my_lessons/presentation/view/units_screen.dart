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
    return Scaffold(
      appBar: AppBarWidget(subject: subject),
      body: Stack(
        children: [
          const GradientBackground(),
          subject == null
              ? const InvalidDataOverlay()
              : MainContent(subject: subject),
        ],
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Subject? subject;

  const AppBarWidget({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        subject?.title ??
            'units_title'
                .tr(), // عنوان الوحدات: اسم المادة أو "الوحدات" (ar) أو "Units" (en)
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
    developer.log('UnitsScreen: Invalid subject data');
    return Center(
      child: Text(
        'invalid_subject_data'
            .tr(), // "بيانات المادة غير صالحة" (ar) أو "Invalid subject data" (en)
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  final Subject subject;

  const MainContent({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [const SectionHeader(), UnitsGrid(subject: subject)],
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
        'units_title'.tr(), // "الوحدات" (ar) أو "Units" (en)
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

class UnitsGrid extends StatelessWidget {
  final Subject subject;

  const UnitsGrid({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<LessonsCubit, LessonsState>(
        builder: (context, state) {
          return switch (state) {
            LessonsLoading() => const LoadingIndicator(),
            LessonsLoaded(subjects: var subjects) => LoadedUnits(
              subject: subject,
              subjects: subjects,
            ),
            LessonsError(message: var message) => ErrorMessage(
              message: message,
            ),
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
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Constants.activeColor),
      ),
    );
  }
}

class LoadedUnits extends StatelessWidget {
  final Subject subject;
  final List<Subject> subjects;

  const LoadedUnits({super.key, required this.subject, required this.subjects});

  @override
  Widget build(BuildContext context) {
    final updatedSubject = subjects.firstWhere(
      (s) => s.id == subject.id,
      orElse: () => subject,
    );
    final units = updatedSubject.units;
    developer.log(
      'UnitsScreen: Units loaded for ${subject.title}: ${units.length}',
    );
    if (units.isEmpty) return const EmptyMessage();
    return GridView.builder(
      padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Constants.smallSpacingForLessons,
        mainAxisSpacing: Constants.smallSpacingForLessons,
        childAspectRatio: 1.2,
      ),
      itemCount: units.length,
      itemBuilder:
          (context, index) => UnitItem(subject: subject, unit: units[index]),
    );
  }
}

class UnitItem extends StatelessWidget {
  final Subject subject;
  final Unit unit;

  const UnitItem({super.key, required this.subject, required this.unit});

  @override
  Widget build(BuildContext context) {
    final isUnitActivated = unit.lessons.any((lesson) => lesson.isActivated);
    developer.log(
      'UnitsScreen: Building unit card: ${unit.title}, activated: $isUnitActivated',
    );
    return Card(
      elevation: isUnitActivated ? 8.0 : 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
      ),
      color: isUnitActivated ? Colors.white : Colors.white.withOpacity(0.5),
      shadowColor: Constants.primaryColor.withOpacity(0.3),
      child: InkWell(
        onTap: () => _navigateToLessons(context, subject, unit),
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius + 4),
        child: UnitContent(
          subject: subject,
          unit: unit,
          isActivated: isUnitActivated,
        ),
      ),
    );
  }

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
}

class UnitContent extends StatelessWidget {
  final Subject subject;
  final Unit unit;
  final bool isActivated;

  const UnitContent({
    super.key,
    required this.subject,
    required this.unit,
    required this.isActivated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Constants.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UnitIcon(subject: subject, isActivated: isActivated),
          const SizedBox(height: Constants.smallSpacingForLessons),
          UnitTitle(unit: unit, isActivated: isActivated),
        ],
      ),
    );
  }
}

class UnitIcon extends StatelessWidget {
  final Subject subject;
  final bool isActivated;

  const UnitIcon({super.key, required this.subject, required this.isActivated});

  @override
  Widget build(BuildContext context) {
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
}

class UnitTitle extends StatelessWidget {
  final Unit unit;
  final bool isActivated;

  const UnitTitle({super.key, required this.unit, required this.isActivated});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${'unit'.tr()} ${unit.title}', // "الوحدة 1" (ar) أو "Unit 1" (en)
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
        'no_units_available'
            .tr(), // "لا توجد وحدات متاحة" (ar) أو "No units available" (en)
        style: Constants.descriptionTextStyle.copyWith(color: Colors.grey),
      ),
    );
  }
}
