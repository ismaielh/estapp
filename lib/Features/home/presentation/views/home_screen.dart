import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

// تعريف الصفحة الرئيسية كـ StatelessWidget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size; // الحصول على أبعاد الشاشة

    return Material(
      child: SizedBox(
        width: mediaQuery.width, // عرض الشاشة الكامل
        height: mediaQuery.height, // ارتفاع الشاشة الكامل
        child: Stack(
          children: [
            // الخلفية العلوية البيضاء
            Container(
              width: mediaQuery.width,
              height: mediaQuery.height / 1.6,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            // الخلفية العلوية البنفسجية مع الصورة والمنحنى
            Container(
              width: mediaQuery.width,
              height: mediaQuery.height / 1.6,
              decoration: const BoxDecoration(
                color: Color(0xff674AEF),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/books.png", // تأكد من وجود الصورة
                  scale: 0.8,
                ),
              ),
            ),
            // الجزء السفلي مع المحتوى
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: mediaQuery.width,
                height:
                    mediaQuery.height / 1.5, // زيادة الارتفاع لرفع الجزء السفلي
                padding: const EdgeInsets.all(20.0), // حشوة خارجية للجزء السفلي
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      70,
                    ), // زاوية مستديرة في الأعلى الأيسر
                    topRight: Radius.circular(
                      70,
                    ), // زاوية مستديرة في الأعلى الأيمن
                  ),
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // توزيع العناصر في المنتصف
                  children: [
                    Text(
                      "welcome_to_app".tr(), // نص ترحيبي مترجم
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff674AEF),
                      ),
                    ),
                    const SizedBox(height: 10), // مسافة بين النص والمربعات
                    // تحديد الحجم الثابت لـ GridView لمنع التمرير
                    SizedBox(
                      height:
                          (mediaQuery.height / 1.5) -
                          90, // زيادة المساحة للمربعات
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(), // منع التمرير
                        crossAxisCount: 2, // عدد الأعمدة في الشبكة
                        crossAxisSpacing: 8, // المسافة الأفقية بين المربعات
                        mainAxisSpacing: 8, // المسافة العمودية بين المربعات
                        children: [
                          _buildMenuItem(
                            context,
                            icon: Icons.person_add,
                            title: "create_account".tr(),
                            onTap: () {
                              context.go('/create-account');
                              // إضافة منطق التنقل إلى صفحة إنشاء الحساب
                            },
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.login,
                            title: "login".tr(),
                            onTap: () {
                              // إضافة منطق التنقل إلى صفحة تسجيل الدخول
                            },
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.play_circle_fill,
                            title: "intro_video".tr(),
                            onTap: () {
                              // إضافة منطق التنقل إلى فيديو تعريفي
                            },
                          ),
                          _buildMenuItem(
                            context,
                            icon: Icons.info,
                            title: "about_program".tr(),
                            onTap: () {
                              // إضافة منطق التنقل إلى صفحة حول البرنامج
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإنشاء كل عنصر في الشبكة
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 6, // إضافة ظل خفيف وجميل
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12.0), // حشوة داخلية للعنصر
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff674AEF).withOpacity(0.9), Colors.purple[300]!],
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
