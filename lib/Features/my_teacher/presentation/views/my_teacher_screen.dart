import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/teacher_models.dart' as teacher;

// الويدجت الرئيسي للصفحة
class MyTeacherScreen extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher;

  const MyTeacherScreen({super.key, required this.selectedTeacher});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCubit, TeacherState>(
      buildWhen: (previous, current) =>
          current is TeacherLoaded || current is TeacherError,
      builder: (context, state) {
        if (state is TeacherLoaded) {
          final currentTeacher = state.teachers.firstWhere(
            (t) => t.id == selectedTeacher.id,
            orElse: () => selectedTeacher,
          );
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
              child: Column(
                children: [
                  TeacherHeader(teacherName: currentTeacher.name),
                  Expanded(child: TeacherContent(selectedTeacher: currentTeacher)), // تغيير الاسم إلى selectedTeacher
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

// ويدجت العنوان
class TeacherHeader extends StatelessWidget {
  final String teacherName;

  const TeacherHeader({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Column(
        children: [
          Text(
            'my_teacher'.tr(),
            style: Constants.titleTextStyle.copyWith(
              color: Constants.backgroundColor,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            teacherName,
            style: Constants.subTitleTextStyle.copyWith(
              fontSize: 20,
              color: Constants.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ويدجت المحتوى
class TeacherContent extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher; // تغيير الاسم من teacher إلى selectedTeacher

  const TeacherContent({super.key, required this.selectedTeacher});

  @override
  Widget build(BuildContext context) {
    final hasBookedSessions = selectedTeacher.sessions.any((session) => session.isBooked); // استخدام selectedTeacher

    return Padding(
      padding: Constants.sectionPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TeacherOptionCard(
            title: 'available_sessions'.tr(),
            icon: Icons.event_available,
            onTap: () {
              context.push('/available-sessions', extra: selectedTeacher); // استخدام selectedTeacher
            },
          ),
          const SizedBox(height: 8),
          TeacherOptionCard(
            title: 'booked_sessions'.tr(),
            icon: Icons.event_busy,
            onTap: () {
              context.push('/booked-sessions', extra: selectedTeacher); // استخدام selectedTeacher
            },
            isEnabled: hasBookedSessions,
          ),
        ],
      ),
    );
  }
}

// ويدجت خيار (كارد)
class TeacherOptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const TeacherOptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
      ),
      color: Constants.cardBackgroundColor.withOpacity(isEnabled ? 0.9 : 0.5),
      child: ListTile(
        leading: Icon(
          icon,
          color: isEnabled ? Constants.primaryColor : Constants.primaryColor.withOpacity(0.5),
          size: 30,
        ),
        title: Text(
          title,
          style: Constants.subTitleTextStyle.copyWith(
            color: isEnabled ? Constants.textColor : Constants.textColor.withOpacity(0.5),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: isEnabled ? Constants.primaryColor : Constants.primaryColor.withOpacity(0.5),
          size: 24,
        ),
        onTap: onTap,
      ),
    );
  }
}