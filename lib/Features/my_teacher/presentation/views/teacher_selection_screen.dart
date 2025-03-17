import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/teacher_models.dart' as teacher;

// الويدجت الرئيسي للصفحة
class TeacherSelectionScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const TeacherSelectionScreen({super.key, required this.args});

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
            TeacherHeader(),
            Expanded(child: TeacherList()),
          ],
        ),
      ),
    );
  }
}

// ويدجت العنوان
class TeacherHeader extends StatelessWidget {
  const TeacherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Text(
        'select_teacher'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Constants.backgroundColor,
          fontSize: 22,
        ),
      ),
    );
  }
}

// ويدجت قائمة المعلمين
class TeacherList extends StatelessWidget {
  const TeacherList({super.key});

  @override
  Widget build(BuildContext context) {
    final args = context.findAncestorWidgetOfExactType<TeacherSelectionScreen>()!.args;
    final teacher.MySubject subject = args['subject'];

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
          final teachers = state.teachers
              .where((t) => t.subjectId == subject.id)
              .toList();

          if (teachers.isEmpty) {
            return Center(
              child: Text(
                'no_teachers_available'.tr(),
                style: Constants.subTitleTextStyle.copyWith(
                  color: Constants.textColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: Constants.sectionPadding,
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final selectedTeacher = teachers[index]; // تغيير الاسم من teacher إلى selectedTeacher
              return TeacherCard(selectedTeacher: selectedTeacher);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ويدجت كارد المعلم
class TeacherCard extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher; // تغيير الاسم من teacher إلى selectedTeacher

  const TeacherCard({super.key, required this.selectedTeacher});

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
          Icons.person,
          color: Constants.primaryColor,
          size: 30,
        ),
        title: Text(
          selectedTeacher.name, // استخدام selectedTeacher بدلاً من teacher
          style: Constants.subTitleTextStyle,
        ),
        trailing: const Icon(
          Icons.arrow_forward,
          color: Constants.primaryColor,
          size: 24,
        ),
        onTap: () {
          context.push('/my-teacher', extra: selectedTeacher); // استخدام selectedTeacher
        },
      ),
    );
  }
}