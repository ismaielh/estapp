import 'package:estapps/Features/my_lessons/presentation/manger/cubit/lessons_cubit.dart';
import 'package:estapps/constants.dart';
import 'package:estapps/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class UnitItem extends StatelessWidget {
  final Unit unit;
  final VoidCallback onTap;

  const UnitItem({
    super.key,
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        title: Row(
          children: [
            const Icon(Icons.folder, color: Constants.inactiveColor, size: 20),
            const SizedBox(width: Constants.smallSpacingForLessons),
            Text(
              "${'unit'.tr()} ${unit.title}",
              style: Constants.unitTextStyle,
            ),
          ],
        ),
        trailing: const Icon(Icons.expand_more, color: Constants.inactiveColor),
        initiallyExpanded: unit.isExpanded, // تأكد من أن الوحدة مفتوحة إذا كانت كذلك
        onExpansionChanged: (expanded) {
          if (expanded != unit.isExpanded) onTap(); // استدعاء onTap فقط إذا تغير الحال
        },
        children: unit.isExpanded
            ? unit.lessons.map((lesson) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      context.push('${AppRouter.lessonDetailScreenPath}/${lesson.id}');
                    },
                    borderRadius: BorderRadius.circular(10.0),
                    child: Row(
                      children: [
                        Icon(
                          _getLessonIcon(lesson.title),
                          size: 30.0,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            "${'lesson'.tr()} ${lesson.title}",
                            style: Constants.lessonTextStyle.copyWith(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()
            : [],
      ),
    );
  }

  IconData _getLessonIcon(String title) {
    final index = int.tryParse(title) ?? 0;
    const icons = [
      Icons.play_lesson,
      Icons.video_library,
      Icons.book,
      Icons.school,
      Icons.library_books,
    ];
    return icons[index % icons.length];
  }
}