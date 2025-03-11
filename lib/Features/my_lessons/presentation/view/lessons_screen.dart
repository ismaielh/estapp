import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class LessonsScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const LessonsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final subject = args['subject'] as Subject;
    final unit = args['unit'] as Unit;

    return BlocProvider(
      create: (context) => LessonsCubit()..loadSubjects(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${'unit'.tr()} ${unit.title}",
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
                          final updatedSubject = state.subjects.firstWhere(
                            (s) => s.id == subject.id,
                            orElse: () => subject,
                          );
                          final updatedUnit = updatedSubject.units.firstWhere(
                            (u) => u.id == unit.id, // استخدام unit.id من args
                            orElse: () => unit,
                          );
                          final lessons = updatedUnit.lessons;
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
                              return Card(
                                elevation: Constants.cardElevation,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                ),
                                color: Constants.cardBackgroundColor,
                                child: InkWell(
                                  onTap: () {
                                    context.push(
                                      '/lesson-detail/${lesson.id}',
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                  child: Padding(
                                    padding: Constants.cardPadding,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _getLessonIcon(lesson.title),
                                          size: 50.0,
                                          color: Constants.inactiveColor,
                                        ),
                                        const SizedBox(height: Constants.smallSpacingForLessons),
                                        Text(
                                          "${'lesson'.tr()} ${lesson.title}",
                                          style: Constants.lessonTextStyle,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is LessonsError) {
                          return Center(child: Text(state.message));
                        }
                        return const Center(child: Text('No lessons available'));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLessonIcon(String title) {
    final index = int.tryParse(title) ?? 0;
    const icons = [
      Icons.play_lesson,
      Icons.video_library,
      Icons.book,
      Icons.school,
      Icons.library_books,
    ];
    return icons[index % icons.length];
  }
}