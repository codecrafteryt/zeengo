import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enus.dart';

class LanguageController extends GetxController {
  LanguageController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _localeKey = 'app_locale';

  static const Locale english = Locale('en', 'US');
  static const Locale arabic = Locale('ar', 'SA');

  late final Rx<Locale> locale;

  bool get isArabic => locale.value.languageCode == 'ar';

  @override
  void onInit() {
    super.onInit();
    locale = Rx<Locale>(_loadSavedLocale());
  }

  Locale _loadSavedLocale() {
    final code = sharedPreferences.getString(_localeKey);
    if (code == 'ar') return arabic;
    return english;
  }

  Future<void> setLocale(Locale value) async {
    if (locale.value == value) return;
    locale.value = value;
    await sharedPreferences.setString(
      _localeKey,
      value.languageCode == 'ar' ? 'ar' : 'en',
    );
    await Get.updateLocale(value);
  }

  Future<void> setEnglish() => setLocale(english);

  Future<void> setArabic() => setLocale(arabic);

  void showLanguagePicker() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                Enus.chooseLanguage.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(Enus.english.tr),
                trailing: !isArabic
                    ? const Icon(Icons.check, color: Color(0xFF6366F1))
                    : null,
                onTap: () async {
                  Get.back();
                  await setEnglish();
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(Enus.arabic.tr),
                trailing: isArabic
                    ? const Icon(Icons.check, color: Color(0xFF6366F1))
                    : null,
                onTap: () async {
                  Get.back();
                  await setArabic();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
