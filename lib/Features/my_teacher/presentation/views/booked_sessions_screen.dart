import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_state.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../models/teacher_models.dart' as teacher;

// الويدجت الرئيسي للصفحة
class BookedSessionsScreen extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher;

  const BookedSessionsScreen({super.key, required this.selectedTeacher});

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
        child: Column(
          children: [
            const BookedSessionsHeader(),
            Expanded(child: BookedSessionsList(selectedTeacher: selectedTeacher)),
          ],
        ),
      ),
    );
  }
}

// ويدجت العنوان
class BookedSessionsHeader extends StatelessWidget {
  const BookedSessionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Text(
        'booked_sessions'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Constants.backgroundColor,
          fontSize: 22,
        ),
      ),
    );
  }
}

// ويدجت قائمة الجلسات المحجوزة
class BookedSessionsList extends StatelessWidget {
  final teacher.MyTeacher selectedTeacher;

  const BookedSessionsList({super.key, required this.selectedTeacher});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherCubit, TeacherState>(
      buildWhen: (previous, current) =>
          current is TeacherLoaded || current is TeacherError,
      builder: (context, state) {
        if (state is TeacherLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherError) {
          return Center(child: Text(state.message));
        } else if (state is TeacherLoaded) {
          final bookedSessions = state.teachers
              .firstWhere((t) => t.id == selectedTeacher.id)
              .sessions
              .where((session) => session.isBooked)
              .toList();

          if (bookedSessions.isEmpty) {
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
            padding: Constants.sectionPadding,
            itemCount: bookedSessions.length,
            itemBuilder: (context, index) {
              final session = bookedSessions[index];
              return BookedSessionCard(session: session);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

// ويدجت كارد الجلسة المحجوزة
class BookedSessionCard extends StatelessWidget {
  final teacher.MySession session;

  const BookedSessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(session.date);

    return Card(
      elevation: Constants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
      ),
      color: Constants.cardBackgroundColor.withOpacity(0.9), // إزالة الشرط المتعلق بـ isPostponed
      child: ListTile(
        title: Text(
          '${'session_date'.tr()}: $formattedDate',
          style: Constants.subTitleTextStyle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'session_duration'.tr()}: ${session.duration.inMinutes} ${'minutes'.tr()}',
              style: Constants.bodyTextStyle,
            ),
            Text(
              '${'session_price'.tr()}: ${session.price} ${'currency'.tr()}',
              style: Constants.bodyTextStyle,
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            final canStart = context.read<TeacherCubit>().canStartVideoCall(session.date);
            if (canStart) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('starting_video_call'.tr()),
                  backgroundColor: Constants.primaryColor,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('cannot_start_call_now'.tr()),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('call'.tr()),
        ),
      ),
    );
  }
}