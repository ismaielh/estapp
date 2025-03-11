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

    if (subject == null) {
      developer.log('UnitsScreen: Invalid subject data');
      return Scaffold(
        body: Center(
          child: Text('Invalid subject data'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          subject.title,
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
                    'units_title'.tr(),
                    style: Constants.titleTextStyle.copyWith(
                      color: Constants.backgroundColor,
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (context, state) {
                      developer.log('UnitsScreen: BlocBuilder state: $state');
                      if (state is LessonsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LessonsLoaded) {
                        final updatedSubject = state.subjects.firstWhere(
                          (s) => s.id == subject.id,
                          orElse: () => subject,
                        );
                        final units = updatedSubject.units;
                        developer.log('UnitsScreen: Units loaded for ${subject.title}: ${units.length}');
                        if (units.isEmpty) {
                          return const Center(child: Text('No units available'));
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
                            // تحقق مما إذا كان هناك درس واحد على الأقل مفعل
                            final isUnitActivated = unit.lessons.any((lesson) => lesson.isActivated);
                            developer.log('UnitsScreen: Building unit card: ${unit.title}, activated: $isUnitActivated');

                            return Card(
                              elevation: isUnitActivated ? 8.0 : 4.0, // زيادة الظل عند التفعيل
                              shape: RoundedRectangleBorder(
                                side: isUnitActivated
                                    ? BorderSide(color: Constants.activeColor, width: 2.0) // حدود ملونة
                                    : BorderSide.none,
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                              ),
                              child: InkWell(
                                onTap: () {
                                  try {
                                    developer.log('UnitsScreen: Navigating to /lessons/${unit.id}');
                                    context.push(
                                      '/lessons/${unit.id}',
                                      extra: {'subject': subject, 'unit': unit},
                                    );
                                  } catch (e) {
                                    developer.log('Navigation error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Navigation error: $e')),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isUnitActivated
                                        ? Colors.greenAccent.withOpacity(0.1) // لون خلفية أفتح
                                        : Constants.cardBackgroundColor,
                                    borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                  ),
                                  child: Padding(
                                    padding: Constants.cardPadding,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          subject.icon ?? Icons.book,
                                          size: 50.0,
                                          color: isUnitActivated
                                              ? Constants.activeColor
                                              : Constants.inactiveColor,
                                        ),
                                        const SizedBox(height: Constants.smallSpacingForLessons),
                                        Text(
                                          'Unit ${unit.title}',
                                          style: isUnitActivated
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
                        developer.log('UnitsScreen: Error state: ${state.message}');
                        return Center(child: Text(state.message));
                      }
                      return const Center(child: Text('No units available'));
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