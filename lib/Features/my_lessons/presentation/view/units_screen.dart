import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:developer' as developer;

// تعليق: شاشة الوحدات (Units) التي تعرض قائمة الوحدات لمادة معينة
class UnitsScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const UnitsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    // تعليق: استخراج المادة من الوسائط (arguments)
    final subject = args['subject'] as Subject?;

    // تعليق: التحقق من صحة بيانات المادة
    if (subject == null) {
      developer.log('UnitsScreen: Invalid subject data');
      return Scaffold(
        body: Center(
          child: Text('invalid_subject_data'.tr(), style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      // تعليق: شريط التطبيق مع عنوان المادة
      appBar: AppBar(
        title: Text(
          subject.title,
          style: Constants.titleTextStyle.copyWith(color: Constants.backgroundColor),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      body: Stack(
        children: [
          // تعليق: خلفية متدرجة من اللون الأساسي إلى لون الخلفية
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
                // تعليق: عنوان القسم "الوحدات"
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
                // تعليق: قائمة الوحدات باستخدام BlocBuilder
                Expanded(
                  child: BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (context, state) {
                      developer.log('UnitsScreen: BlocBuilder state: $state');
                      if (state is LessonsLoading) {
                        // تعليق: عرض مؤشر تحميل أثناء جلب البيانات
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is LessonsLoaded) {
                        // تعليق: تحديث المادة بناءً على الحالة الجديدة
                        final updatedSubject = state.subjects.firstWhere(
                          (s) => s.id == subject.id,
                          orElse: () => subject,
                        );
                        final units = updatedSubject.units;
                        developer.log('UnitsScreen: Units loaded for ${subject.title}: ${units.length}');
                        if (units.isEmpty) {
                          // تعليق: عرض رسالة في حال عدم وجود وحدات
                          return Center(child: Text('no_units_available'.tr()));
                        }
                        // تعليق: عرض الوحدات في شبكة (Grid)
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
                            final isUnitActivated = unit.lessons.any((lesson) => lesson.isActivated);
                            developer.log('UnitsScreen: Building unit card: ${unit.title}, activated: $isUnitActivated');

                            return Card(
                              elevation: isUnitActivated ? 8.0 : 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                              ),
                              child: InkWell(
                                onTap: () {
                                  try {
                                    // تعليق: الانتقال إلى شاشة الدروس عند النقر على الوحدة
                                    developer.log('UnitsScreen: Navigating to /lessons/${unit.id}');
                                    context.push('/lessons/${unit.id}', extra: {'subject': subject, 'unit': unit});
                                  } catch (e) {
                                    developer.log('Navigation error: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('navigation_error'.tr(args: [e.toString()])),
                                    ));
                                  }
                                },
                                borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isUnitActivated ? Colors.white : Constants.cardBackgroundColor,
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
                                          color: isUnitActivated ? Constants.activeColor : Constants.inactiveColor,
                                        ),
                                        const SizedBox(height: Constants.smallSpacingForLessons),
                                        // تعليق: عرض عنوان الوحدة مع الترجمة
                                        Text(
                                          'unit'.tr() + ' ${unit.title}',
                                          style: isUnitActivated ? Constants.activeTextStyle : Constants.subjectTextStyle,
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
                      return Center(child: Text('no_units_available'.tr()));
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