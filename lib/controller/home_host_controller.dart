
  import 'package:get/get_state_manager/src/simple/get_controllers.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class HomeHostController extends GetxController {
    final SharedPreferences sharedPreferences;

    HomeHostController({required this.sharedPreferences});
  }