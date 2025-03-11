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
                    'my_lessons_title'.tr(),
                    style: Constants.titleTextStyle.copyWith(
                      color: Constants.backgroundColor,
                      fontSize: 28,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (context, state) {
                      if (state is LessonsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LessonsLoaded) {
                        final subjects = state.subjects;
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
                            developer.log('Processing subject: ${subject.title}, units: ${subject.units.length}');
                            return Card(
                              elevation: Constants.cardElevation,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                              ),
                              color: Constants.cardBackgroundColor,
                              child: InkWell(
                                onTap: () {
                                  try {
                                    developer.log('Navigating to /units/${subject.id}');
                                    context.push(
                                      '/units/${subject.id}',
                                      extra: {'subject': subject},
                                    );
                                  } catch (e) {
                                    developer.log('Navigation error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Navigation error: $e')),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                child: Padding(
                                  padding: Constants.cardPadding,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        subject.icon ?? Icons.book,
                                        size: 50.0,
                                        color: Constants.inactiveColor,
                                      ),
                                      const SizedBox(height: Constants.smallSpacingForLessons),
                                      Text(
                                        subject.title,
                                        style: Constants.subjectTextStyle,
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
                      return const Center(child: Text('No subjects available'));
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