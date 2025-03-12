import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

// تعليق: شاشة الدروس التي تعرض قائمة الدروس داخل وحدة معينة
class LessonsScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const LessonsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final subject = args['subject'] as Subject;
    final unit = args['unit'] as Unit;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'lessons_title'.tr(),
          style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Constants.primaryColor, Constants.backgroundColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: Constants.sectionPadding,
                  child: Text(
                    'lessons_title'.tr(),
                    style: Constants.titleTextStyle.copyWith(
                      color: Constants.backgroundColor,
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (context, state) {
                      if (state is LessonsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LessonsLoaded) {
                        final updatedUnit = state.subjects
                            .expand((s) => s.units)
                            .firstWhere((u) => u.id == unit.id, orElse: () => unit);
                        final lessons = updatedUnit.lessons;
                        if (lessons.isEmpty) {
                          return Center(child: Text('no_lessons_available'.tr()));
                        }
                        return GridView.builder(
                          padding: const EdgeInsets.all(Constants.smallSpacingForLessons),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: Constants.smallSpacingForLessons,
                            mainAxisSpacing: Constants.smallSpacingForLessons,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            final isLessonActivated = lesson.isActivated;
                            developer.log('LessonsScreen: Lesson ${lesson.title} activated: $isLessonActivated, sections: ${lesson.sections.length}');

                            return Card(
                              elevation: isLessonActivated ? 8.0 : 4.0,
                              shape: RoundedRectangleBorder(
                                side: isLessonActivated
                                    ? BorderSide(color: Constants.activeColor, width: 2.0)
                                    : BorderSide.none,
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (!isLessonActivated) {
                                    // تعليق: الانتقال إلى شاشة التفعيل إذا لم يكن الدرس مفعلاً
                                    context.push('/activation', extra: {
                                      'subject': subject,
                                      'unit': unit,
                                      'lesson': lesson,
                                    });
                                  } else {
                                    // تعليق: الانتقال إلى شاشة الدرس المفعل
                                    developer.log('Navigating to activated lesson ${lesson.id}');
                                    context.push('/activated-lesson/${lesson.id}', extra: {
                                      'subject': subject,
                                      'unit': unit,
                                      'lesson': lesson,
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isLessonActivated ? Colors.white : Constants.cardBackgroundColor,
                                    borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                  ),
                                  child: Padding(
                                    padding: Constants.cardPadding,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.bookmark,
                                          size: 50.0,
                                          color: isLessonActivated ? Constants.activeColor : Constants.inactiveColor,
                                        ),
                                        const SizedBox(height: Constants.smallSpacingForLessons),
                                        Text(
                                          'lesson'.tr() + ' ${lesson.title}',
                                          style: isLessonActivated
                                              ? Constants.activeTextStyle
                                              : Constants.subjectTextStyle,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is LessonsError) {
                        return Center(child: Text(state.message));
                      }
                      return Center(child: Text('no_lessons_available'.tr()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}