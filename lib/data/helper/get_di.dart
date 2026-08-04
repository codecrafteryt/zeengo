import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth_controller.dart';
import '../../controller/language_controller.dart';
import '../../controller/map_controller.dart';
import '../../controller/theme_controller.dart';
import '../api_provider/api_provider.dart';
import '../repos/auth_repo/auth_repo.dart';

class DependencyInjection {
  static Future<void> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    Get.put<SharedPreferences>(sharedPreferences, permanent: true);
    Get.put(
      LanguageController(sharedPreferences: sharedPreferences),
      permanent: true,
    );
    Get.put(
      ThemeController(sharedPreferences: sharedPreferences),
      permanent: true,
    );
    Get.lazyPut(() => ApiProvider(), fenix: true);
    Get.lazyPut(() => AuthRepo(apiProvider: Get.find()), fenix: true);

    Get.lazyPut(
      () => AuthController(
        authRepo: Get.find(),
        sharedPreferences: Get.find(),
      ),
      fenix: true,
    );

    Get.put(
      MapController(sharedPreferences: sharedPreferences),
      permanent: true,
    );
  }
}
