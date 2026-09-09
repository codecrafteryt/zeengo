import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enus.dart';
import '../utils/values/app_palette.dart';
import '../utils/values/my_images.dart';
import '../views/widgets/cupertino_option_sheet.dart';

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

  Widget _leading(Color color) {
    return SvgPicture.asset(
      MyImages.translateFlatSvg,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  void showLanguagePicker() {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    final palette = AppPalette.of(context);

    CupertinoOptionSheet.show(

      context: context,
      title: Enus.chooseLanguage.tr,
      cancelLabel: Enus.cancel.tr,
      options: [
        CupertinoSheetOption(
          label: Enus.english.tr,
          leading: _leading(palette.icon),
          selected: !isArabic,
          onTap: setEnglish,
        ),
        CupertinoSheetOption(
          label: Enus.arabic.tr,
          leading: _leading(palette.icon),
          selected: isArabic,
          onTap: setArabic,
        ),
      ],
    );
  }
}
