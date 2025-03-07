// أحداث تغيير اللغة
abstract class LanguageEvent {}

class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;

  ChangeLanguageEvent(this.languageCode);
}