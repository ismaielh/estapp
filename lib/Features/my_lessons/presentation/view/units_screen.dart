import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class UnitsScreen extends StatelessWidget {
  final Subject subject;

  const UnitsScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonsCubit()..loadSubjects(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            subject.id == 'subject1' ? "mathematics".tr() : "science".tr(),
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
                        if (state is LessonsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is LessonsLoaded) {
                          final updatedSubject = state.subjects.firstWhere(
                            (s) => s.id == subject.id,
                            orElse: () => subject,
                          );
                          final units = updatedSubject.units;
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
                              return Card(
                                elevation: Constants.cardElevation,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                ),
                                color: Constants.cardBackgroundColor,
                                child: InkWell(
                                  onTap: () {
                                    context.push(
                                      '/lessons/${unit.id}',
                                      extra: {'subject': subject, 'unit': unit},
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                  child: Padding(
                                    padding: Constants.cardPadding,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder,
                                          size: 50.0,
                                          color: Constants.inactiveColor,
                                        ),
                                        const SizedBox(height: Constants.smallSpacingForLessons),
                                        Text(
                                          "${'unit'.tr()} ${unit.title}",
                                          style: Constants.unitTextStyle,
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
                        return const Center(child: Text('No units available'));
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
}