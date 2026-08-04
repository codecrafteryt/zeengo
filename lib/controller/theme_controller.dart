import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enus.dart';
import '../utils/values/app_palette.dart';
import '../utils/values/my_color.dart';
import '../views/widgets/custom_text_widget.dart';

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
    Get.bottomSheet(
      SafeArea(
        child: Builder(
          builder: (context) {
            final palette = AppPalette.of(context);
            return Container(
              decoration: BoxDecoration(
                color: palette.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Obx(() {
                return Column(
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
                      Enus.chooseTheme.tr,
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                    ),
                    const SizedBox(height: 8),
                    _tile(
                      context: context,
                      label: Enus.themeSystem.tr,
                      selected: mode.value == 'system',
                      onTap: () async {
                        Get.back();
                        await setMode('system');
                      },
                    ),
                    _tile(
                      context: context,
                      label: Enus.themeLight.tr,
                      selected: mode.value == 'light',
                      onTap: () async {
                        Get.back();
                        await setMode('light');
                      },
                    ),
                    _tile(
                      context: context,
                      label: Enus.themeDark.tr,
                      selected: mode.value == 'dark',
                      onTap: () async {
                        Get.back();
                        await setMode('dark');
                      },
                    ),
                  ],
                );
              }),
            );
          },
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _tile({
    required BuildContext context,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final palette = AppPalette.of(context);
    return ListTile(
      leading: Icon(
        Icons.brightness_6_rounded,
        color: palette.icon,
      ),
      title: CustomTextWidget(
        label,
        color: palette.textPrimary,
      ),
      trailing: selected
          ? const Icon(Icons.check, color: MyColors.darkPurple)
          : null,
      onTap: onTap,
    );
  }
}
