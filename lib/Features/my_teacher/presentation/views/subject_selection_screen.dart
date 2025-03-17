import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/teacher_models.dart' as teacher;

// الويدجت الرئيسي للصفحة
class SubjectSelectionScreen extends StatelessWidget {
  final teacher.MyGradeLevel gradeLevel;

  const SubjectSelectionScreen({super.key, required this.gradeLevel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Constants.primaryColor.withOpacity(0.9),
              Constants.primaryColor.withOpacity(0.5),
              Constants.primaryColor.withOpacity(0.1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: const Column(
          children: [
            SubjectHeader(),
            Expanded(child: SubjectList()),
          ],
        ),
      ),
    );
  }
}

// ويدجت العنوان
class SubjectHeader extends StatelessWidget {
  const SubjectHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Text(
        'select_subject'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Constants.backgroundColor,
          fontSize: 22,
        ),
      ),
    );
  }
}

// ويدجت قائمة المواد
class SubjectList extends StatelessWidget {
  const SubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final gradeLevel = context.findAncestorWidgetOfExactType<SubjectSelectionScreen>()!.gradeLevel;
    return BlocBuilder<TeacherCubit, TeacherState>(
      buildWhen: (previous, current) =>
          current is TeacherLoaded || current is TeacherError,
      builder: (context, state) {
        if (state is TeacherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherError) {
          return Center(
            child: Text(
              state.message,
              style: Constants.descriptionTextStyle.copyWith(
                color: Constants.errorColorForCreateAccount,
              ),
            ),
          );
        } else if (state is TeacherLoaded) {
          final subjects = state.subjects
              .where((subject) => subject.gradeLevelId == gradeLevel.id)
              .toList();

          if (subjects.isEmpty) {
            return Center(
              child: Text(
                'no_subjects_available'.tr(),
                style: Constants.subTitleTextStyle.copyWith(
                  color: Constants.textColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: Constants.sectionPadding,
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final currentSubject = subjects[index]; // تغيير الاسم لتجنب التعارض إن وجد
              return SubjectCard(subject: currentSubject, gradeLevel: gradeLevel);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ويدجت كارد المادة
class SubjectCard extends StatelessWidget {
  final teacher.MySubject subject;
  final teacher.MyGradeLevel gradeLevel;

  const SubjectCard({super.key, required this.subject, required this.gradeLevel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
      ),
      color: Constants.cardBackgroundColor.withOpacity(0.9),
      child: ListTile(
        leading: const Icon(
          Icons.book,
          color: Constants.primaryColor,
          size: 30,
        ),
        title: Text(
          subject.title,
          style: Constants.subTitleTextStyle,
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Constants.primaryColor,
          size: 24,
        ),
        onTap: () {
          context.push(
            '/select-teacher',
            extra: {
              'gradeLevel': gradeLevel,
              'subject': subject,
            },
          );
        },
      ),
    );
  }
}