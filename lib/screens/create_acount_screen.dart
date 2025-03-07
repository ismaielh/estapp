import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// تعريف صفحة إنشاء الحساب كـ StatelessWidget
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size; // الحصول على أبعاد الشاشة

    return Scaffold(
      resizeToAvoidBottomInset: true, // تفعيل رفع الشاشة عند ظهور الـ keyboard
      body: SizedBox(
        width: mediaQuery.width, // عرض الشاشة الكامل
        height: mediaQuery.height, // ارتفاع الشاشة الكامل
        child: Stack(
          children: [
            // الخلفية العلوية البيضاء
            Container(
              width: mediaQuery.width,
              height: mediaQuery.height / 1.6,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            // الخلفية العلوية البنفسجية مع الصورة والمنحنى
            Container(
              width: mediaQuery.width,
              height: mediaQuery.height / 1.6,
              decoration: const BoxDecoration(
                color: Color(0xff674AEF),
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
              ),
              child: Center(
                child: Image.asset(
                  "assets/images/books.png", // تأكد من وجود الصورة
                  scale: 0.8,
                ),
              ),
            ),
            // الجزء السفلي مع نموذج الحقول
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: mediaQuery.width,
                height: mediaQuery.height / 1.5, // زيادة الارتفاع لاحتواء الحقول
                padding: const EdgeInsets.all(20.0), // حشوة خارجية للجزء السفلي
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),  // زاوية مستديرة في الأعلى الأيسر
                    topRight: Radius.circular(70), // زاوية مستديرة في الأعلى الأيمن
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // إضافة مسافة سفلية ديناميكية
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // توزيع العناصر في المنتصف
                    children: [
                      Text(
                        "create_account_title".tr(), // عنوان الصفحة مترجم
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff674AEF),
                        ),
                      ),
                      const SizedBox(height: 20), // مسافة بين العنوان والحقول
                      _buildTextField(
                        context,
                        icon: Icons.person,
                        label: "student_name".tr(),
                        hint: "enter_student_name".tr(),
                      ),
                      const SizedBox(height: 10), // مسافة بين الحقول
                      _buildTextField(
                        context,
                        icon: Icons.person_outline,
                        label: "father_name".tr(),
                        hint: "enter_father_name".tr(),
                      ),
                      const SizedBox(height: 10), // مسافة بين الحقول
                      _buildTextField(
                        context,
                        icon: Icons.family_restroom,
                        label: "family_name".tr(),
                        hint: "enter_family_name".tr(),
                      ),
                      const SizedBox(height: 10), // مسافة بين الحقول
                      _buildTextField(
                        context,
                        icon: Icons.phone,
                        label: "mobile_number".tr(),
                        hint: "enter_mobile_number".tr(),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10), // مسافة بين الحقول
                      _buildTextField(
                        context,
                        icon: Icons.account_circle,
                        label: "username".tr(),
                        hint: "enter_username".tr(),
                      ),
                      const SizedBox(height: 10), // مسافة بين الحقول
                      _buildTextField(
                        context,
                        icon: Icons.lock,
                        label: "password".tr(),
                        hint: "enter_password".tr(),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20), // مسافة قبل الزر
                      Material(
                        color: const Color(0xff674AEF),
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            // إضافة منطق إنشاء الحساب هنا
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 60,
                            ),
                            child: Text(
                              "create_account_button".tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // مساحة إضافية لضمان عدم التغطية
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإنشاء حقل نص مع أيقونة وحجم ثابت
  Widget _buildTextField(BuildContext context,
      {required IconData icon,
      required String label,
      required String hint,
      TextInputType keyboardType = TextInputType.text,
      bool obscureText = false}) {
    return SizedBox(
      width: 300, // حجم ثابت لجميع الحقول
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Color(0xff674AEF)),
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}