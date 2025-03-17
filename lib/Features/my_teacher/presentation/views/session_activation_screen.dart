import 'package:estapps/Features/my_teacher/presentation/manager/teacher_cubit/teacher_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import '../models/teacher_models.dart' as teacher;

// الويدجت الرئيسي للصفحة
class SessionActivationScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const SessionActivationScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final teacher.MyTeacher selectedTeacher = args['teacher'];
    final teacher.MySession session = args['session'];

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
            const SessionActivationHeader(),
            Expanded(
              child: SessionActivationContent(
                session: session,
                selectedTeacher: selectedTeacher,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت العنوان
class SessionActivationHeader extends StatelessWidget {
  const SessionActivationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
      child: Text(
        'session_activation'.tr(),
        style: Constants.titleTextStyle.copyWith(
          color: Constants.backgroundColor,
          fontSize: 22,
        ),
      ),
    );
  }
}

// ويدجت المحتوى
class SessionActivationContent extends StatelessWidget {
  final teacher.MySession session;
  final teacher.MyTeacher selectedTeacher;

  const SessionActivationContent({
    super.key,
    required this.session,
    required this.selectedTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SessionDetailsCard(session: session),
          const SizedBox(height: 16),
          BookButton(
            onPressed: () {
              context.read<TeacherCubit>().bookSession(
                    selectedTeacher.id,
                    session.id,
                  );
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('success'.tr()),
                  content: Text('session_booked'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.pop();
                      },
                      child: Text('ok'.tr()),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ويدجت كارد تفاصيل الجلسة
class SessionDetailsCard extends StatelessWidget {
  final teacher.MySession session;

  const SessionDetailsCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy').format(session.date);

    return Card(
      elevation: Constants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.cardBorderRadius),
      ),
      color: Constants.cardBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'session_date'.tr()}: $formattedDate',
              style: Constants.subTitleTextStyle.copyWith(
                fontSize: 16,
                color: Constants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${'session_duration'.tr()}: ${session.duration.inMinutes} ${'minutes'.tr()}',
              style: Constants.descriptionTextStyle.copyWith(
                fontSize: 14,
                color: Constants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${'session_price'.tr()}: ${session.price.toStringAsFixed(0)} ${'currency'.tr()}',
              style: Constants.descriptionTextStyle.copyWith(
                fontSize: 14,
                color: Constants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${'payment_method'.tr()}: ${'seritel_cash'.tr()}',
              style: Constants.descriptionTextStyle.copyWith(
                fontSize: 14,
                color: Constants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ويدجت زر الحجز
class BookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BookButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 12,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        'book'.tr(),
        style: Constants.buttonTextStyle.copyWith(
          fontSize: 16,
        ),
      ),
    );
  }
}