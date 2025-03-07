import 'package:estapps/constants.dart';
import 'package:flutter/material.dart';


// مكون عنصر الشبكة كـ StatelessWidget
class MenuItem extends StatelessWidget {
  final IconData icon; // الأيقونة
  final String title; // العنوان المترجم
  final VoidCallback onTap; // الدالة التي تُنفذ عند النقر

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6, // ظل خفيف للعنصر
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap, // الدالة التي تُنفذ عند النقر
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12.0), // حشوة داخلية
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Constants.primaryColor.withOpacity(0.9), Colors.purple[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.white), // أيقونة العنصر
              const SizedBox(height: 8), // مسافة بين الأيقونة والنص
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}