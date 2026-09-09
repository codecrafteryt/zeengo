import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enus.dart';
import '../utils/values/app_palette.dart';
import '../views/widgets/cupertino_option_sheet.dart';

class ThemeController extends GetxController {
  ThemeController({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  static const String _key = 'app_theme_mode';

  /// `system` | `light` | `dark`
  late final RxString mode;

  ThemeMode get themeMode {
    return switch (mode.value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  bool get isDark {
    if (mode.value == 'dark') return true;
    if (mode.value == 'light') return false;
    return Get.isPlatformDarkMode;
  }

  @override
  void onInit() {
    super.onInit();
    mode = RxString(sharedPreferences.getString(_key) ?? 'system');
  }

  Future<void> setMode(String value) async {
    if (mode.value == value) return;
    mode.value = value;
    await sharedPreferences.setString(_key, value);
    Get.changeThemeMode(themeMode);
  }

  void showThemePicker() {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    final palette = AppPalette.of(context);
    final leading = Icon(Icons.brightness_6_rounded, color: palette.icon);

    CupertinoOptionSheet.show(
      context: context,
      title: Enus.chooseTheme.tr,
      cancelLabel: Enus.cancel.tr,
      options: [
        CupertinoSheetOption(
          label: Enus.themeSystem.tr,
          leading: leading,
          selected: mode.value == 'system',
          onTap: () => setMode('system'),
        ),
        CupertinoSheetOption(
          label: Enus.themeLight.tr,
          leading: Icon(Icons.brightness_6_rounded, color: palette.icon),
          selected: mode.value == 'light',
          onTap: () => setMode('light'),
        ),
        CupertinoSheetOption(
          label: Enus.themeDark.tr,
          leading: Icon(Icons.brightness_6_rounded, color: palette.icon),
          selected: mode.value == 'dark',
          onTap: () => setMode('dark'),
        ),
      ],
    );
  }
}
