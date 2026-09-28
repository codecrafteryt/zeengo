import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/auth_controller.dart';
import '../../controller/around_controller.dart';
import '../../controller/explore_russia_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/language_controller.dart';
import '../../controller/my_trip_controller.dart';
import '../../controller/notification_controller.dart';
import '../../controller/socket_controller.dart';
import '../../controller/task_controller.dart';
import '../../controller/theme_controller.dart';
import '../api_provider/api_provider.dart';
import '../repos/auth_repo/auth_repo.dart';
import '../repos/home_repo/home_repo.dart';
import '../repos/notification_repo/notification_repo.dart';
import '../repos/task_repo/task_repo.dart';

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
      () => HomeRepo(
        apiProvider: Get.find(),
        sharedPreferences: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => NotificationRepo(
        apiProvider: Get.find(),
        sharedPreferences: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => TaskRepo(
        apiProvider: Get.find(),
        sharedPreferences: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => AuthController(
        authRepo: Get.find(),
        sharedPreferences: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => HomeController(
        homeRepo: Get.find(),
        sharedPreferences: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => TaskController(taskRepo: Get.find()),
      fenix: true,
    );

    Get.put(
      NotificationController(notificationRepo: Get.find()),
      permanent: true,
    );
    Get.put(
      SocketController(sharedPreferences: sharedPreferences),
      permanent: true,
    );

    Get.put(AroundController(), permanent: true);
    Get.put(ExploreRussiaController(), permanent: true);
    Get.put(MyTripController(), permanent: true);
  }
}
