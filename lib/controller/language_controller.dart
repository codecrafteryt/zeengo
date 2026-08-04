import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enus.dart';
import '../utils/values/app_palette.dart';
import '../utils/values/my_color.dart';
import '../utils/values/my_images.dart';
import '../views/widgets/custom_text_widget.dart';

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

  Widget _leadingTranslateIcon(Color color) {
    return SvgPicture.asset(
      MyImages.translateFlatSvg,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  void showLanguagePicker() {
    Get.bottomSheet(
      SafeArea(
        child: Builder(
          builder: (context) {
            final palette = AppPalette.of(context);
            return Container(
              decoration: BoxDecoration(
                color: palette.card,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
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
                        color: palette.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextWidget(
                    Enus.chooseLanguage.tr,
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: _leadingTranslateIcon(palette.icon),
                    title: CustomTextWidget(
                      Enus.english.tr,
                      color: palette.textPrimary,
                    ),
                    trailing: !isArabic
                        ? const Icon(Icons.check, color: MyColors.darkPurple)
                        : null,
                    onTap: () async {
                      Get.back();
                      await setEnglish();
                    },
                  ),
                  ListTile(
                    leading: _leadingTranslateIcon(palette.icon),
                    title: CustomTextWidget(
                      Enus.arabic.tr,
                      color: palette.textPrimary,
                    ),
                    trailing: isArabic
                        ? const Icon(Icons.check, color: MyColors.darkPurple)
                        : null,
                    onTap: () async {
                      Get.back();
                      await setArabic();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
