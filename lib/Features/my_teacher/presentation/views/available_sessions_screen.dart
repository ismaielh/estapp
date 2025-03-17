import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../models/teacher_models.dart' as teacher;

// الويدجت الرئيسي للصفحة
class AvailableSessionsScreen extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher;

  const AvailableSessionsScreen({super.key, required this.selectedTeacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(16.0), // إضافة هوامش خارجية حول الشاشة
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
            const AvailableSessionsHeader(),
            const SizedBox(height: 20), // إضافة مساحة بين العنوان والمحتوى
            Expanded(
              child: AvailableSessionsContent(selectedTeacher: selectedTeacher),
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت العنوان
class AvailableSessionsHeader extends StatelessWidget {
  const AvailableSessionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Text(
        'available_sessions'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Constants.backgroundColor,
          fontSize: 22,
        ),
        textAlign: TextAlign.center, // محاذاة النص للمنتصف لتحسين الظهور
      ),
    );
  }
}

// ويدجت المحتوى
class AvailableSessionsContent extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher;

  const AvailableSessionsContent({super.key, required this.selectedTeacher});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCubit, TeacherState>(
      buildWhen:
          (previous, current) =>
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
          final teacherSessions =
              state.teachers
                  .firstWhere((t) => t.id == selectedTeacher.id)
                  .sessions
                  .where((session) => !session.isBooked)
                  .toList();

          if (teacherSessions.isEmpty) {
            return Center(
              child: Text(
                'no_sessions_available'.tr(),
                style: Constants.subTitleTextStyle.copyWith(
                  color: Constants.textColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ), // تقليص الحشوة العمودية
            itemCount: teacherSessions.length,
            itemBuilder: (context, index) {
              final session = teacherSessions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0), // مساحة بين الكروت
                child: SessionCard(
                  session: session,
                  onTap: () {
                    context.push(
                      '/session-activation',
                      extra: {'teacher': selectedTeacher, 'session': session},
                    );
                  },
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ويدجت كارد الجلسة
class SessionCard extends StatelessWidget {
  final teacher.MySession session;
  final VoidCallback onTap;

  const SessionCard({super.key, required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(session.date);

    return Card(
      elevation: Constants.cardElevation,
      margin: EdgeInsets.zero, // إزالة الهوامش الخارجية للكارد
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
      ),
      color: Constants.cardBackgroundColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0), // تقليص الحشوة الداخلية
          child: Row(
            children: [
              const Icon(
                Icons.event,
                color: Constants.primaryColor,
                size: 32, // تقليص حجم الأيقونة
              ),
              const SizedBox(width: 12), // تقليص المسافة بين الأيقونة والنص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'session_date'.tr()}: $formattedDate',
                      style: Constants.subTitleTextStyle.copyWith(
                        fontSize: 14, // تقليص حجم النص
                        color: Constants.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'session_duration'.tr()}: ${session.duration.inMinutes} ${'minutes'.tr()}',
                      style: Constants.descriptionTextStyle.copyWith(
                        fontSize: 12, // تقليص حجم النص
                        color: Constants.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${'session_price'.tr()}: ${session.price.toStringAsFixed(0)} ${'currency'.tr()}',
                      style: Constants.descriptionTextStyle.copyWith(
                        fontSize: 12, // تقليص حجم النص
                        color: Constants.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: Constants.primaryColor,
                size: 20, // تقليص حجم الأيقونة
              ),
            ],
          ),
        ),
      ),
    );
  }
}
